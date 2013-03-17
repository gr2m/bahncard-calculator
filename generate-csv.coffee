casper = require('casper').create();
[username, password] = casper.cli.args

unless username and password
  casper.echo "USAGE"
  casper.echo "casperjs generate-csv.coffee <username> <password>"
  casper.exit()

HOMEPAGE_URL = 'http://www.bahn.de/'
USERNAME = username
PASSWORD = password
CSV_FILE = 'tickets.csv'
data = []

casper.on 'error', (msg, backtrace) ->
  @echo msg
  @echo backtrace

casper.on 'remote.message', (msg) ->
  @echo msg

casper.start HOMEPAGE_URL, ->
  @echo "homepage loaded."

  options = 
    'username': USERNAME
    'password': PASSWORD
  @fill '#login-form', options, true


casper.then ->
  @echo "signed in."

  @clickLabel("Meine Buchungen", 'a')

casper.then ->
  @echo "Meine Buchungen form loaded."

  # BAHN only allows to go back 11 months in time
  d = new Date
  day   = d.getDate() + 1
  month = d.getMonth() + 2
  year  = d.getFullYear() - 1

  @fill '#formular', 
    'vonDatumTag'  : day
    'vonDatumMonat': month
    'vonDatumJahr' : year
  @click '#formular .button-inside.right  button'

getCurrentContent = -> 
  casper.evaluate -> document.querySelector('table').innerText

gatherMetaData = ->

  data = data.concat JSON.parse casper.evaluate ->
    try 
      orders = []
      rowNodes = document.querySelector('table').querySelectorAll('tbody tr')
      for rowNode in rowNodes
        
        cellNodes = rowNode.querySelectorAll('td')
        continue if cellNodes.length is 1 # footer row


        orders.push
          id : cellNodes[0].innerText
          bookingDate : cellNodes[1].innerText
          travelDate : cellNodes[2].innerText
          title : cellNodes[4].innerText
          link : rowNode.querySelector('a.arrowlink').href

    catch error
      console.log "ERROR"
      console.log error

    return JSON.stringify(orders)

  @echo "data: #{data.length}"

  if @exists 'table input.linknext'
    @echo "loading next page"
    currentContent = getCurrentContent()
    @thenClick('table input.linknext').then ->
      @waitFor ( ->
        console.log 'check'
        currentContent isnt getCurrentContent()
      ), gatherMetaData
    
  else
    @echo "NO MORE next page!"
    @echo "no checking detail pages"
    gatherDetailData()

index = 0
gatherDetailData = ->
  index++
  if index <= data.length
    current = data[index - 1]

    casper.open(current.link).then ->
      console.log "getting details for #{current.title}"
      details = @evaluate ->

        try 
          # getting only first row, ignoring the others (usually reservations only)
          cellNodes = document.querySelector('.brsDetailsKomponenteTable + table tbody tr').querySelectorAll('td')

          json = JSON.stringify 
            description : cellNodes[2].innerText
            receiptNumber : cellNodes[3].innerText
            price : cellNodes[5].innerText
        catch error
          console.log "ERROR"
          console.log error

        return json

      details = JSON.parse details

      current.description = details.description
      current.receiptNumber = details.receiptNumber
      current.price = details.price.replace(' EUR','')
      current.originalPrice = current.price

      # get Bahncard type
      current.bahncard  = current.description.match(/\bBC (\d+)/)?.pop()
      current.class     = current.description.match(/\b(1|2)\. Kl\./)?.pop()
      current.priceType = current.description.match(/(Normalpreis|Sparpreis|Spezial)/)?.pop()

      if current.bahncard
        current.bahncard = parseInt(current.bahncard) 

      delete current.link

      gatherDetailData()
      

casper.then gatherMetaData
casper.run ->
  console.log JSON.stringify data, '', '  '

  resultsCSV = []
  keys = Object.keys(data[0])
  resultsCSV.push keys.join(';')
  for ticket in data
    resultsCSV.push keys.map( (key) -> ticket[key] ).join(";")
  require('fs').write CSV_FILE, resultsCSV.join("\n"), 'w'
  @exit()