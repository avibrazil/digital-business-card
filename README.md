digital-business-card
=====================

An effort to evolve the old paper business card into newer social formats as Passbook, HTML5+hCard, VCF.

The QRcode on the Passbook points to an URL on your website (mine is https://Avi.Alkalay.net/card/) that intelligently
delivers your digital business card as a Passbook or visual and mobile-friendly HTML5+hCard with links to Passbook and VCF.
All with good-looking design and nice icons.

The whole idea is to avoid paper business cards in an easy and work-environment-acceptable way. The journey is:

1. I show my business card in Passbook format on my smartphone.
2. The other person scans the code with iPhone-native Passbook software and get my card as a Passbook from my website.
3. Non-iPhone users scan the same code and get pointed to a mobile-friendly page on my website that visualy resembles a phone contact from the address book.
4. There are visual icons to help the user to download my VCF file and, again, the Passbook card.

The page rendered shows your personal data as e-mail. But it is safe from e-mail crawlers because the HTML is just a template that is mixed with
the actual data using JavaScript on the visitor browser. There is no server-side engine, no PHP, no MariaDB and nothing dynamic
is required on the web server side. All are plain static files.
