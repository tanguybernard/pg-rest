create schema api;

create table api.todos (
                           id serial primary key,
                           done boolean not null default false,
                           task text not null,
                           due timestamptz
);

insert into api.todos (done, task) values (true,'finish tutorial 0'), (false,'pat self on back');

-- Make a role to use for anonymous web requests. When a request comes in, PostgREST will switch into this role in the database to run queries.
create role web_anon nologin;

grant usage on schema api to web_anon;
--web_anon can only SELECT on todos table
grant select on api.todos to web_anon;

-- It’s a good practice to create a dedicated role for connecting to the database, instead of using the highly privileged postgres role.
-- So we’ll do that, name the role authenticator and also grant it the ability to switch to the web_anon role :

create role authenticator noinherit login password 'mysecretpassword';
grant web_anon to authenticator;

-- Create a role called "todo_user" for users who authenticate with the API.
-- This role will have the authority to do anything to the todolist.
create role todo_user nologin;
grant todo_user to authenticator;

grant usage on schema api to todo_user; -- Accorder le privilège USAGE sur le schema api au rôle todo_user :
grant all on api.todos to todo_user;
grant usage, select on sequence api.todos_id_seq to todo_user;