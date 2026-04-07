from flask import Flask, render_template, request, redirect, url_for, flash
import mysql.connector
from datetime import datetime
import config

app = Flask(__name__)
app.secret_key = 'your-secret-key-here'

def get_db_connection():
    """Create and return a database connection"""
    return mysql.connector.connect(
        host=config.DB_HOST,
        user=config.DB_USER,
        password=config.DB_PASSWORD,
        database=config.DB_NAME,
        charset='utf8mb4'
    )

@app.route('/')
def index():
    """Home page with navigation"""
    return render_template('index.html')

@app.route('/books')
def books():
    """Display all books"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('''
        SELECT b.isbn, b.book_title, b.page_count, b.publication_year, 
               b.genre, b.language, a.author_name, p.publisher_id
        FROM book b
        JOIN author a ON b.author_name = a.author_name AND b.author_birth_date = a.birth_date
        JOIN publisher p ON b.publisher_id = p.publisher_id
        ORDER BY b.book_title
    ''')
    books = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('books.html', books=books)

@app.route('/users')
def users():
    """Display all users"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM user ORDER BY username')
    users = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('users.html', users=users)

@app.route('/reviews')
def reviews():
    """Display all reviews using the view"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM user_reviews_view ORDER BY review_date DESC')
    reviews = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('reviews.html', reviews=reviews)

@app.route('/booklists')
def booklists():
    """Display all booklists"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('''
        SELECT bl.booklist_id, bl.booklist_name, bl.book_count, u.username
        FROM booklist bl
        JOIN user u ON bl.user_id = u.user_id
        ORDER BY bl.booklist_name
    ''')
    booklists = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('booklists.html', booklists=booklists)

@app.route('/booklist/<int:booklist_id>')
def booklist_details(booklist_id):
    """Display books in a specific booklist"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    # Get booklist info
    cursor.execute('''
        SELECT bl.booklist_name, u.username
        FROM booklist bl
        JOIN user u ON bl.user_id = u.user_id
        WHERE bl.booklist_id = %s
    ''', (booklist_id,))
    booklist_info = cursor.fetchone()
    
    # Get books in the booklist
    cursor.execute('''
        SELECT b.book_title, b.author_name, bcb.reading_status
        FROM booklist_contains_book bcb
        JOIN book b ON bcb.isbn = b.isbn
        WHERE bcb.booklist_id = %s
    ''', (booklist_id,))
    books = cursor.fetchall()
    
    cursor.close()
    conn.close()
    return render_template('booklist_details.html', booklist_info=booklist_info, books=books)

@app.route('/challenges')
def challenges():
    """Display all reading challenges"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('''
        SELECT rc.challenge_id, rc.challenge_name, rc.start_date, rc.end_date, 
               u.username
        FROM reading_challenge rc
        JOIN user u ON rc.user_id = u.user_id
        ORDER BY rc.start_date DESC
    ''')
    challenges = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('challenges.html', challenges=challenges)

@app.route('/authors')
def authors():
    """Display all authors"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM author ORDER BY author_name')
    authors = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('authors.html', authors=authors)

@app.route('/add_user', methods=['GET', 'POST'])
def add_user():
    """Add a new user"""
    if request.method == 'POST':
        user_id = request.form['user_id']
        username = request.form['username']
        email = request.form['email']
        bio = request.form.get('bio', '')
        join_date = datetime.now().strftime('%Y-%m-%d')
        
        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute('''
                INSERT INTO user (user_id, username, email, join_date, bio)
                VALUES (%s, %s, %s, %s, %s)
            ''', (user_id, username, email, join_date, bio))
            conn.commit()
            flash('User added successfully!', 'success')
            return redirect(url_for('users'))
        except mysql.connector.Error as err:
            flash(f'Error adding user: {err}', 'error')
        finally:
            cursor.close()
            conn.close()
    
    return render_template('add_user.html')

@app.route('/add_book', methods=['GET', 'POST'])
def add_book():
    """Add a new book"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        isbn = request.form['isbn']
        book_id = request.form['book_id']
        book_title = request.form['book_title']
        page_count = request.form.get('page_count')
        publication_year = request.form.get('publication_year')
        description = request.form.get('description')
        language = request.form.get('language')
        genre = request.form['genre']
        publisher_id = request.form['publisher_id']
        author_name = request.form['author_name']
        author_birth_date = request.form['author_birth_date']
        
        try:
            cursor.execute('''
                INSERT INTO book (isbn, book_id, book_title, page_count, publication_year, 
                                description, language, genre, publisher_id, author_name, author_birth_date)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            ''', (isbn, book_id, book_title, page_count, publication_year, 
                  description, language, genre, publisher_id, author_name, author_birth_date))
            conn.commit()
            flash('Book added successfully!', 'success')
            return redirect(url_for('books'))
        except mysql.connector.Error as err:
            flash(f'Error adding book: {err}', 'error')
    
    # Get authors and publishers for dropdowns
    cursor.execute('SELECT author_name, birth_date FROM author ORDER BY author_name')
    authors = cursor.fetchall()
    cursor.execute('SELECT publisher_id FROM publisher ORDER BY publisher_id')
    publishers = cursor.fetchall()
    
    cursor.close()
    conn.close()
    return render_template('add_book.html', authors=authors, publishers=publishers)

@app.route('/add_review', methods=['GET', 'POST'])
def add_review():
    """Add a new book review"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        user_id = request.form['user_id']
        isbn = request.form['isbn']
        review_id = request.form['review_id']
        review_text = request.form['review_text']
        review_date = datetime.now().strftime('%Y-%m-%d')
        
        try:
            cursor.execute('''
                INSERT INTO user_reviews_book (user_id, isbn, review_id, review_text, 
                                              likes_count, review_date)
                VALUES (%s, %s, %s, %s, 0, %s)
            ''', (user_id, isbn, review_id, review_text, review_date))
            conn.commit()
            flash('Review added successfully!', 'success')
            return redirect(url_for('reviews'))
        except mysql.connector.Error as err:
            flash(f'Error adding review: {err}', 'error')
    
    # Get users and books for dropdowns
    cursor.execute('SELECT user_id, username FROM user ORDER BY username')
    users = cursor.fetchall()
    cursor.execute('SELECT isbn, book_title FROM book ORDER BY book_title')
    books = cursor.fetchall()
    
    cursor.close()
    conn.close()
    return render_template('add_review.html', users=users, books=books)

@app.route('/add_author', methods=['GET', 'POST'])
def add_author():
    """Add a new author"""
    if request.method == 'POST':
        author_name = request.form['author_name']
        birth_date = request.form['birth_date']
        author_id = request.form['author_id']
        biography = request.form.get('biography', '')
        
        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute('''
                INSERT INTO author (author_name, birth_date, author_id, biography)
                VALUES (%s, %s, %s, %s)
            ''', (author_name, birth_date, author_id, biography))
            conn.commit()
            flash('Author added successfully!', 'success')
            return redirect(url_for('authors'))
        except mysql.connector.Error as err:
            flash(f'Error adding author: {err}', 'error')
        finally:
            cursor.close()
            conn.close()
    
    return render_template('add_author.html')

@app.route('/add_booklist', methods=['GET', 'POST'])
def add_booklist():
    """Add a new booklist"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        booklist_id = request.form['booklist_id']
        booklist_name = request.form['booklist_name']
        user_id = request.form['user_id']
        book_count = 0  # Initially empty
        
        try:
            cursor.execute('''
                INSERT INTO booklist (booklist_id, booklist_name, book_count, user_id)
                VALUES (%s, %s, %s, %s)
            ''', (booklist_id, booklist_name, book_count, user_id))
            conn.commit()
            flash('Booklist added successfully!', 'success')
            return redirect(url_for('booklists'))
        except mysql.connector.Error as err:
            flash(f'Error adding booklist: {err}', 'error')
    
    # Get users for dropdown
    cursor.execute('SELECT user_id, username FROM user ORDER BY username')
    users = cursor.fetchall()
    
    cursor.close()
    conn.close()
    return render_template('add_booklist.html', users=users)

@app.route('/add_challenge', methods=['GET', 'POST'])
def add_challenge():
    """Add a new reading challenge"""
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    if request.method == 'POST':
        challenge_id = request.form['challenge_id']
        challenge_name = request.form['challenge_name']
        challenge_year = request.form.get('challenge_year')
        challenge_type = request.form.get('challenge_type')
        start_date = request.form['start_date']
        end_date = request.form['end_date']
        user_id = request.form['user_id']
        
        try:
            cursor.execute('''
                INSERT INTO reading_challenge (challenge_id, challenge_name, challenge_year, 
                                               challenge_type, start_date, end_date, user_id)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            ''', (challenge_id, challenge_name, challenge_year, challenge_type, 
                  start_date, end_date, user_id))
            conn.commit()
            flash('Reading challenge added successfully!', 'success')
            return redirect(url_for('challenges'))
        except mysql.connector.Error as err:
            flash(f'Error adding challenge: {err}', 'error')
    
    # Get users for dropdown
    cursor.execute('SELECT user_id, username FROM user ORDER BY username')
    users = cursor.fetchall()
    
    cursor.close()
    conn.close()
    return render_template('add_challenge.html', users=users)

if __name__ == '__main__':
    app.run(debug=True, port=5000)
