#Όλα τα reading challenges στα οποία συμμετέχει ο χρήστης με id 103 τα οποία δημιουργήθηκαν μετά την 01/01/2020
SELECT rc.challenge_id, rc.challenge_name, rc.start_date
FROM Reading_Challenge rc
JOIN User_Participates_Reading_Challenge up ON rc.challenge_id = up.challenge_id
WHERE up.user_id = 103 
AND rc.start_date > '2020-01-01';