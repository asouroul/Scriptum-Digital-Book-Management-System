
# 1. Διαχειριστής (Admin)
# Περιγραφή: Έχει πλήρη πρόσβαση παντού (Δημιουργία ρόλων, στατιστικά, πλήρης διαχείριση).

DROP USER IF EXISTS 'admin_user'@'localhost';
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'adminPass123!';

# Ανάθεση όλων των δικαιωμάτων (ALL PRIVILEGES) στη βάση BookDB
GRANT ALL PRIVILEGES ON BookDB.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

# 2. Αναγνώστης (Reader)
# Περιγραφή: Μπορεί να βλέπει βιβλία, να φτιάχνει προφίλ, λίστες, να βάζει βαθμολογίες και κριτικές.

DROP USER IF EXISTS 'reader_user'@'localhost';
CREATE USER 'reader_user'@'localhost' IDENTIFIED BY 'readerPass123!';

# Δικαίωμα να βλέπει (SELECT) όλα τα δεδομένα (Βιβλία, Συγγραφείς, άλλους χρήστες, Challenges)
GRANT SELECT ON BookDB.* TO 'reader_user'@'localhost';

# Δικαίωμα να εισάγει (INSERT) και να ενημερώνει (UPDATE) τις δικές του ενέργειες:
# Κριτικές, Βαθμολογίες, Λίστες, Συμμετοχή σε Challenges
GRANT INSERT, UPDATE, DELETE ON BookDB.User_Reviews_Book TO 'reader_user'@'localhost';
GRANT INSERT, UPDATE, DELETE ON BookDB.User_Rates_Book TO 'reader_user'@'localhost';
GRANT INSERT, UPDATE, DELETE ON BookDB.Booklist TO 'reader_user'@'localhost';
GRANT INSERT, UPDATE, DELETE ON BookDB.Booklist_Contains_Book TO 'reader_user'@'localhost';
GRANT INSERT, UPDATE, DELETE ON BookDB.User_Participates_Reading_Challenge TO 'reader_user'@'localhost';
GRANT INSERT, UPDATE, DELETE ON BookDB.User_Follows_User TO 'reader_user'@'localhost';

# Δικαίωμα να επεξεργάζεται το προφίλ του (User table)
GRANT UPDATE ON BookDB.User TO 'reader_user'@'localhost';

# 3. Εκδοτικός Οίκος (Publisher)
# Περιγραφή: Μπορεί να προσθέτει νέα βιβλία και να ενημερώνει τα στοιχεία του.

DROP USER IF EXISTS 'publisher_user'@'localhost';
CREATE USER 'publisher_user'@'localhost' IDENTIFIED BY 'pubPass123!';

# Δικαίωμα να βλέπει τα δεδομένα
GRANT SELECT ON BookDB.* TO 'publisher_user'@'localhost';

# Δικαίωμα να ΠΡΟΣΘΕΤΕΙ (INSERT) και να ΕΝΗΜΕΡΩΝΕΙ (UPDATE) Βιβλία
GRANT INSERT, UPDATE ON BookDB.Book TO 'publisher_user'@'localhost';

# Δικαίωμα να ενημερώνει τα στοιχεία του δικού του Εκδοτικού Οίκου
GRANT UPDATE ON BookDB.Publisher TO 'publisher_user'@'localhost';

# Εφαρμογή των δικαιωμάτων
FLUSH PRIVILEGES;