#Όλοι οι τίτλοι, οι συγγραφείς και τα isbn των βιβλίων που έχουν για συγγραφέα τον Ντοστογιέφσκι ή τον Κορτάσαρ
SELECT book_title, isbn, author_name
FROM Book
WHERE author_name = 'Φιόντορ Ντοστογιέφσκι' 
   OR author_name = 'Χούλιο Κορτάσαρ';