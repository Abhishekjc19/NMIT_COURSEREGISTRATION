-- Fix username to match USN (uppercase)
UPDATE users 
SET username = '1NT23AI004' 
WHERE username = '1nt23ai004';

-- Verify the change
SELECT username, role FROM users WHERE username = '1NT23AI004';

COMMIT;
