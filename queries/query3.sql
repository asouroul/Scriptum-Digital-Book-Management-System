#Όλοι οι χρήστες που δεν έχουν συμμετάσχει σε κανένα reading challenge
SELECT user_id, username
FROM User
WHERE user_id NOT IN (
    SELECT user_id 
    FROM User_Participates_Reading_Challenge
);