# Scriptum-Digital-Book-Management-System
A comprehensive relational database system for managing books, authors, reviews, and reading communities

---
 
## 📖 Overview
 
Scriptum is a full-stack web application designed as a digital library platform where users can:
- 📕 Browse and discover books from an extensive catalog
- ✍️ Write and read reviews from the community
- 📊 Rate books and track reading progress
- 📋 Create custom reading lists and organize collections
- 🎯 Participate in reading challenges
- 👥 Follow other readers and build a reading community
 
Built as part of the **Database Systems** course at Aristotle University of Thessaloniki, this project demonstrates advanced database design principles, normalization, and real-world application development.
 
---

## ✨ Features
 
### For Readers
- **Personal Library Management** - Create custom booklists and track reading status (want-to-read, currently-reading, read)
- **Social Reading** - Follow other users and discover books through community reviews
- **Reading Challenges** - Join or create reading challenges with customizable goals and timeframes
- **Reviews & Ratings** - Share detailed book reviews and rate books on a 5-star scale
- **Advanced Search** - Find books by title, author, genre, publisher, or ISBN
 
### For Publishers
- **Book Management** - Add new titles and update book information
- **Publisher Profiles** - Maintain publisher details and contact information
- **Analytics Access** - View statistics on published books
 
### For Administrators
- **Complete Database Control** - Full CRUD operations on all entities
- **User Management** - Create and manage user roles and permissions
- **Statistical Reports** - Generate insights on platform usage and book trends
 
---
 
## 🏗️ Architecture
 
### Database Schema
 
The system is built on a normalized relational database with the following core entities:
 
```
├── User (900K+ expected users)
├── Book (200K+ titles)
├── Author (25K+ authors)
├── Publisher
├── Booklist
├── Reading_Challenge
├── User_Reviews_Book (500K+ reviews)
├── User_Rates_Book (2M+ ratings)
├── User_Follows_User
├── User_Participates_Reading_Challenge
└── Booklist_Contains_Book
```
 
### Technology Stack
 
**Backend**
- Python 3.8+ with Flask 3.0
- MySQL 8.0 for data persistence
- mysql-connector-python for database connectivity
 
**Frontend**
- HTML5 & CSS3
- Jinja2 templating engine
- Responsive design with custom CSS
 
**Database Features**
- Complex join queries across multiple tables
- Database views for optimized read operations
- Role-based access control (RBAC)
- Referential integrity with foreign key constraints
 
---

 ## 🚀 Installation
 
### Prerequisites
 
- Python 3.8 or higher
- MySQL Server 8.0+
- pip (Python package manager)
 
### Quick Start
 
1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/scriptum.git
   cd scriptum
   ```
 
2. **Set up the database**
   ```bash
   mysql -u root -p < Scriptum_dbdump.sql
   ```
 
3. **Install Python dependencies**
   ```bash
   pip install -r requirements.txt
   ```
 
4. **Configure database connection**
   
   Edit `config.py` and add your MySQL credentials:
   ```python
   DB_HOST = 'localhost'
   DB_USER = 'root'
   DB_PASSWORD = 'your_mysql_password'
   DB_NAME = 'bookdb'
   ```
 
5. **Run the application**
   ```bash
   python app.py
   ```
 
6. **Access the application**
   
   Open your browser and navigate to: `http://localhost:5000`
 
---

## 📊 Entity-Relationship Model
 
 
### Key Design Decisions
 
1. **Composite Primary Keys** - Author identified by (author_name, birth_date) to handle authors with identical names
2. **M:N Relationships** - Junction tables for reviews, ratings, booklists, and challenges
3. **Weak Entity** - Reading_Challenge depends on User for existence
4. **Referential Integrity** - Cascading deletes and updates maintain data consistency
 
---

 
## 🔐 User Roles & Permissions
 
### Administrator (`admin_user`)
```sql
-- Full database access with grant privileges
GRANT ALL PRIVILEGES ON BookDB.* TO 'admin_user'@'localhost' WITH GRANT OPTION;
```
 
### Reader (`reader_user`)
```sql
-- Can view all content, manage personal reviews, ratings, and booklists
GRANT SELECT ON BookDB.* TO 'reader_user'@'localhost';
GRANT INSERT, UPDATE, DELETE ON BookDB.User_Reviews_Book TO 'reader_user'@'localhost';
-- ... additional permissions for personal content
```
 
### Publisher (`publisher_user`)
```sql
-- Can add/update books and manage publisher information
GRANT SELECT ON BookDB.* TO 'publisher_user'@'localhost';
GRANT INSERT, UPDATE ON BookDB.Book TO 'publisher_user'@'localhost';
```
 
See `users.sql` for complete role definitions.
 
---

 
## 📂 Project Structure
 
```
scriptum/
│
├── app.py                          # Main Flask application
├── config.py                       # Database configuration
├── requirements.txt                # Python dependencies
│
├── Scriptum_dbdump.sql            # Complete database schema & sample data
├── Scriptum.mwb                   # MySQL Workbench model file
├── Scriptum.png                   # ER diagram visualization
├── users.sql                      # User roles and permissions setup
│
├── templates/                      # Jinja2 HTML templates
│   ├── base.html                  # Base template with navigation
│   ├── index.html                 # Home page
│   ├── books.html                 # Book catalog
│   ├── authors.html               # Author directory
│   ├── users.html                 # User listing
│   ├── reviews.html               # Review feed
│   ├── booklists.html             # Booklist browser
│   ├── challenges.html            # Reading challenges
│   ├── add_book.html              # Book creation form
│   ├── add_author.html            # Author creation form
│   ├── add_user.html              # User registration
│   ├── add_review.html            # Review submission
│   ├── add_booklist.html          # Booklist creation
│   └── add_challenge.html         # Challenge creation
│
├── queries/                        # Sample SQL queries
│   ├── query1.sql                 # Books by author and genre
│   ├── query2.sql                 # Top-rated books by publisher
│   ├── query3.sql                 # Users without challenges
│   ├── query4.sql                 # Books by multiple authors
│   └── query5.sql                 # User's reading challenges
│
└── docs/
    └── Scriptum_Doc.pdf  # Full project documentation (Greek)
```
 
---

## 🎯 Database Views
 
### ACTIVE_USERS_VIEW
Lists all users who have written at least one review after a specified date.
 
```sql
SELECT username 
FROM User 
WHERE user_id IN (
    SELECT user_id 
    FROM User_Reviews_Book 
    WHERE review_date > '2025-01-01'
);
```
 
### USER_REVIEWS_VIEW
Comprehensive view of all reviews with user details and book information.
 
```sql
SELECT u.username, b.book_title, r.review_text, r.review_date, r.likes_count
FROM User u
JOIN User_Reviews_Book r ON u.user_id = r.user_id
JOIN Book b ON r.isbn = b.isbn;
```
 
---

 
## 📝 Sample Queries
 
### Find Fiction Books by Fyodor Dostoevsky
```sql
SELECT book_title, isbn, publication_year
FROM Book
WHERE author_name = 'Φιόντορ Ντοστογιέφσκι' 
  AND genre = 'fiction';
```
 
### Top-Rated Books from Specific Publisher
```sql
SELECT b.book_title
FROM Book b
JOIN User_Rates_Book r ON b.isbn = r.isbn
WHERE r.rating_value = 5
  AND b.publisher_id = 503;
```
 
### Users Not Participating in Any Challenge
```sql
SELECT user_id, username
FROM User
WHERE user_id NOT IN (
    SELECT user_id 
    FROM User_Participates_Reading_Challenge
);
```
 
See the `queries/` directory for more examples.
 
---
 
## 🎨 Features Showcase
 
### Book Catalog
Browse through an extensive collection with filtering by author, genre, and publication year.
 
### Review System
- Write detailed reviews with character limit
- Like/upvote reviews from other readers
- View review history for each book
 
### Reading Lists
- Create unlimited custom booklists
- Track reading status per book
- Share lists with the community
 
### Reading Challenges
- Set personal reading goals
- Track progress over time
- Compete with friends
 
---

## 📚 Documentation
 
Complete project documentation (in Greek) is available in `docs/Scriptum_Doc.pdf`, including:
 
- **Entity-Relationship Model** - Detailed ER diagrams with cardinalities
- **Relational Schema** - Complete table definitions and constraints
- **Normalization Analysis** - BCNF compliance verification
- **Use Cases** - User stories and system requirements
- **Relational Algebra** - Query formulations in relational algebra
 
---

## 👥 Team
 
**Ομάδα 13 - Database Systems Project**
 
- **Αλέξανδρος Σουρουλλάς** - asouroul@ece.auth.gr
- **Γεώργιος Βρης** - vrisgeor@ece.auth.gr
- **Έλενα Λαζαρίδου** - lazaridoueg@ece.auth.gr
 
*Aristotle University of Thessaloniki - School of Electrical & Computer Engineering*
 
---
