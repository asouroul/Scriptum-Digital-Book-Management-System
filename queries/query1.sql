# Όλα τα βιβλία του συγγραφέα Φιόντορ Ντοστογιέφσκι  που ανήκουν στο genre fiction
SELECT book_title, isbn, publication_year
FROM Book
WHERE author_name = 'Φιόντορ Ντοστογιέφσκι' 
AND genre = 'fiction';