# Linux Assignment

### Task 1 [V1](task-1%2Fundublicate-v1.sh) / [V2](task-1%2Fundublicate-v2.sh)

Create script to identify and remove duplicate image files in a given directory, ensuring that only one instance of each
image is retained. The files to be processed are stored in the duplicate_files.zip. Use of the uniq command is not
allowed. Try to solve the task using a single line of Bash code.

Idea: Using `sha256` hashing method to find hashes of all files, then delete file which hash already exists. Time and space complexity: `O(n)`
Usage: Copy code to your `~/.bashrc$ file` Use command "remDuplicates {`\$Path`}" to delete all duplicates in directory {`\$Path`}, if empty it will be applies in current directory. 
### Task 2 - code [here](task-2%2Fexctarct_code.sh)

Write a script that performs the following tasks. (only bash is allowed )

1. Unpack archive_1.zip and find the file that contains code
2. Extract the code from file
3. Generate a new code by adding your ID to the code from step 2 (e.g.,
   'CodeWord_21BD000001')
4. Replace the code from step 2 with the new one and recreate the archive

Idea: DFS search. Recursively search for desired file by unzipping zip files, then make desired change, zip unzipped files while returning back.
### Task 3 - code [here](task-3%2Fconfigure-ssh.sh)

Create a script that configures SSH key-based authentication on a remote server. The script should automatically

1. Generate an SSH key pair on the local machine (if it doesn’t exist)
2. Copy the public key to the remote server
3. Ensure the proper permissions and setup on the remote server for key-based
   authentication
   The script should handle all steps without any manual intervention, except for executing the script.

Usage: copy code to your `.bashrc` file, now you can apply command `setup_ssh {user} {host}` to actually set up your ssh with linux based server. It will automatically create public and private keys, copy public key to server and apply `chmod` things. You just need to enter your password first time, then you can connect to your server without password. 

### Task 4

Create simple API. Then, create a directory /home/logs and redirect all logs to log files in that folder while your
application is running. Limit the number of files to 3 (delete others) and set a log size limit of 1MB. Save the
execution time of your log rotations to /home/log_rotates.log.
Note: you can't do anything with your application, make changes ONLY at the infrastructure level.

### Task 5

Create a unit file for your API from task #4. Create a user with limited privileges, allowing only application
execution (any other level of access for the user - must be justified ).
Your application should start every time your system is launched and restart whenever application exits due to some
errors.

### Task 6 - code [top-n-heaviest-files.sh](task-6%2Ftop-n-heaviest-files.sh)

Write a script to find top-5 heaviest files in your /home directory in descending order, based on their size. Example
for /Desktop

Usage: `bash top-n-heaviest-files.sh 10` 10 is optional, default is 5

### Task 7

Write a script to assign default RW permissions for newly created files in the /home/logs directory for the user from
Task 5.

### Task 8 - code [change-job-name.sh](task-8%2Fchange-job-name.sh)

You are given a file - "example.nomad." Write a script that will change the job name (the part specified in parentheses,
job "example") to any name that can be passed to the script. The changes should be applied to the original file -
example.nomad

Usage: `bash change-job-name.sh example.nomad "new-job-name"`

### Task 9

Close network access to your API service for everyone except one device - the one from which you send requests to your
service.

### Task 10

Make your API service accessible to chosen servers by name. For example, instead of 172.30.240.25:8080 => mysite.

### Task 11

Prepare script to run N instances of your API service and balance incoming traffic between these instances. You can’t
use load balancer like Nginx.

### Task 12

Your task is to create a Makefile that allows me to easily run your tasks above. The Makefile should allow for
flexibility and reusability of components, making it easy to extend or modify. Use arguments for parametrization, where
possible.

### Task 13

Add documentation, where required. Use as a reference -
https://docs.divio.com/documentation-system/

