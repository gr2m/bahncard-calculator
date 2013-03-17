BahnCard Calculator
=====================

This project uses [casperjs](http://casperjs.org/) to login to your bahn.de account
and gather all the tickets from the past 11 months (because that's all they give us...)
and turns it into a CSV (because they forgot about that feature, right?)

As of now, it only gathers the data, but does not calculate 
what BahnCard would have saved the most. That shouldn't be 
hard to add though. The hard part is done.


Usage
-------

```sh
$ casperjs generate-csv.coffee <username> <password>
```

replace <username> and <password> with your own your credentials.

The output looks like

| id | bookingDate | travelDate | title | receiptNumber | price | bahncard | class | priceType |
| --- | --- | --- | --- | --- | ---:| --- | --- | --- |
| ABC456 | 10.01.2013 | 12.01.2013 | Hanau Hbf - Bonn Hbf | 12345678 | 69,75 | 25 | 2 | Normalpreis |
| ABC456 | 26.12.2012 | 15.01.2013 | Hanau Hbf - Berlin Ostbahnhof | 12345678 | 118,00 |  | 1 | Sparpreis |
| ABC456 | 12.10.2012 | 19.10.2012 | Zürich HB - Mannheim Hbf | 12345678 | 80,90 | 25 | 2 | Spezial |
| ABC456 | 18.09.2012 | 19.09.2012 | Hanau Hbf - Frankfurt(Main)Hbf | 12345678 | 9,75 | 25 | 2 | Normalpreis |
| ABC456 | 17.09.2012 | 29.09.2012 | Hanau Hbf - Wien Westbahnhof | 12345678 | 168,00 |  | 1 | Spezial |
| ABC456 | 23.08.2012 | 10.10.2012 | Berlin Hbf - Zürich HB | 12345678 | 99,00 |  | 1 | Spezial |
| ABC456 | 23.08.2012 | 19.09.2012 | Zürich HB - Berlin Hbf | 12345678 | 110,45 |  | 1 | Spezial |
| ABC456 | 21.07.2012 | 29.07.2012 | Berlin Ostbahnhof - Hanau Hbf | 97814063 | 99,00 |  | 1 | Sparpreis |
| ABC456 | 02.07.2012 | 03.07.2012 | Hanau Hbf - Darmstadt Hbf | 12345678 | 12,35 | 25 | 2 | Normalpreis |
| ABC456 | 29.06.2012 | 10.07.2012 | Hanau Hbf - Berlin Ostbahnhof | 12345678 | 99,00 |  | 1 | Sparpreis |
| ABC456 | 23.06.2012 | 30.06.2012 | Zürich HB - Mannheim Hbf | 12345678 | 44,20 | 25 | 2 | Spezial |
| ABC456 | 21.06.2012 | 30.06.2012 | Lindau Hbf - Mannheim Hbf | 12345678 | 33,00 | 25 | 2 | Sparpreis |
| ABC456 | 30.04.2012 | 10.05.2012 | Berlin Ostbahnhof - Kronberg(Taunus) | 12345678 | 74,25 | 25 | 1 | Sparpreis |
| ABC456 | 30.04.2012 | 11.05.2012 | Hanau Hbf - Fribourg | 12345678 | 81,70 | 25 | 1 | Spezial |
| ABC456 | 23.04.2012 | 30.04.2012 | Hanau Hbf - Berlin Ostbahnhof | 12345678 | 74,25 | 25 | 1 | Sparpreis |


License 
---------

WTFPL – Do What the Fuck You Want to Public License