#Όλοι οι τίτλοι όλων των βιβλίων από ένα συγκεκριμένο εκδοτικό οίκο με βαθμολογία 5.
SELECT b.book_title
FROM book b
JOIN user_rates_book r ON b.isbn = r.isbn
WHERE r.rating_value = 5
  AND publisher_id = 503;