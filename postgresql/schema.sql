CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE relations_user_task;
DROP TABLE tasks;

DROP TABLE relations_user_content;
DROP TABLE contents;

DROP TABLE relations_user_file;
DROP TABLE files;

DROP TABLE relations_user_playlist;
DROP TABLE playlists;

DROP TABLE relations_user_assembly;
DROP TABLE assemblies;

DROP TABLE relations_user_device;
DROP TABLE devices;

DROP TABLE relations_user_group;
DROP TABLE groups;

DROP INDEX confirmation_codes_needle;
DROP TABLE confirmation_codes;

DROP INDEX users_id;
DROP INDEX users_email;
DROP TABLE users;

CREATE TABLE users (
  id UUID NOT NULL,
  email bytea,
  name bytea,
  surname bytea,
  created date NOT NULL,
  updated date NOT NULL
);

CREATE UNIQUE INDEX users_id ON users (id);
CREATE UNIQUE INDEX users_email ON users (email);

CREATE TABLE confirmation_codes (
  needle bytea,
  code smallint NOT NULL,
  confirmed boolean NOT NULL,
  created serial NOT NULL
);

CREATE UNIQUE INDEX confirmation_codes_needle ON confirmation_codes (needle);

CREATE TABLE files (
  id UUID NOT NULL,
  path text NOT NULL,
  url text NOT NULL,
  extension varchar(8) NOT NULL,
  type varchar(16) NOT NULL,
  size integer NOT NULL,
  created date NOT NULL
);

CREATE UNIQUE INDEX files_id ON files (id);
CREATE INDEX files_url ON files (url);

CREATE TABLE relations_user_file (
  user_id UUID NOT NULL,
  file_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_file_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_file_file_id FOREIGN KEY(file_id) REFERENCES files(id)
);

CREATE INDEX relations_user_file_file_id_i ON relations_user_file (file_id);

CREATE TABLE playlists (
  id UUID NOT NULL,
  name varchar(64) NOT NULL,
  sum smallint NOT NULL,
  created date NOT NULL,
  updated date NOT NULL
);

CREATE UNIQUE INDEX playlists_id ON playlists (id);
CREATE INDEX playlists_name ON playlists (name);

CREATE TABLE relations_user_playlist (
  user_id UUID NOT NULL,
  playlist_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_playlist_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_playlist_playlist_id FOREIGN KEY(playlist_id) REFERENCES playlists(id)
);


CREATE TABLE contents (
  id UUID NOT NULL,
  name varchar(64) NOT NULL,
  file_id UUID NOT NULL,
  playlist_id UUID NOT NULL,
  duration smallint NOT NULL,
  serial_number  smallint NOT NULL,
  created date NOT NULL,
  updated date NOT NULL,
  CONSTRAINT contents_file_id FOREIGN KEY(file_id) REFERENCES files(id),
  CONSTRAINT contents_playlist_id FOREIGN KEY(playlist_id) REFERENCES playlists(id)
);

CREATE UNIQUE INDEX contents_id ON contents (id);
CREATE INDEX contents_name ON contents (name);

CREATE TABLE relations_user_content (
  user_id UUID NOT NULL,
  content_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_content_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_content_content_id FOREIGN KEY(content_id) REFERENCES contents(id)
);

CREATE INDEX relations_user_content_content_id_i ON relations_user_content (content_id);

CREATE TABLE groups (
  id UUID NOT NULL,
  name varchar(64) NOT NULL,
  sum smallint NOT NULL,
  created date NOT NULL,
  updated date NOT NULL
);

CREATE UNIQUE INDEX groups_id ON groups (id);
CREATE INDEX groups_name ON groups (name);

CREATE TABLE relations_user_group (
  user_id UUID NOT NULL,
  group_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_group_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_group_group_id FOREIGN KEY(group_id) REFERENCES groups(id)
);

CREATE UNIQUE INDEX relations_user_group_group_id_i ON relations_user_group (group_id);

CREATE TABLE devices (
  id UUID NOT NULL,
  ip varchar(64) NOT NULL,
  latitude numeric NOT NULL,
  longitude numeric NOT NULL,
  description varchar(256) NOT NULL,
  is_active boolean NOT NULL,
  group_id UUID NOT NULL,
  created date NOT NULL,
  updated date NOT NULL,
  CONSTRAINT devices_group_id FOREIGN KEY(group_id) REFERENCES groups(id)
);

CREATE UNIQUE INDEX devices_id ON devices (id);
CREATE INDEX devices_ip ON devices (ip);
CREATE INDEX devices_description ON devices (description);

CREATE TABLE relations_user_device (
  user_id UUID NOT NULL,
  device_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_device_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_device_device_id FOREIGN KEY(device_id) REFERENCES devices(id)
);

CREATE INDEX relations_user_device_device_id_i ON relations_user_device (device_id);

CREATE TABLE tasks (
  id UUID NOT NULL,
  name varchar(64) NOT NULL,
  playlist_id UUID NOT NULL,
  group_id UUID NOT NULL,
  type varchar(16) NOT NULL,
  day smallint NULL,
  start_hour smallint NOT NULL,
  end_hour smallint NOT NULL,
  start_minute smallint NOT NULL,
  end_minute smallint NOT NULL,
  start_hm smallint NOT NULL,
  end_hm smallint NOT NULL,
  sum smallint NOT NULL,
  created date NOT NULL,
  updated date NOT NULL,
  CONSTRAINT tasks_playlist_id FOREIGN KEY(playlist_id) REFERENCES playlists(id),
  CONSTRAINT tasks_group_id FOREIGN KEY(group_id) REFERENCES groups(id)
);

CREATE UNIQUE INDEX tasks_id ON tasks (id);
CREATE INDEX tasks_name ON tasks (name);
CREATE INDEX tasks_group_id ON tasks (group_id);

CREATE TABLE relations_user_task (
  user_id UUID NOT NULL,
  task_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_task_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_task_task_id FOREIGN KEY(task_id) REFERENCES tasks(id)
);

CREATE UNIQUE INDEX relations_user_task_task_id_i ON relations_user_task (task_id);


CREATE TABLE assemblies (
  id UUID NOT NULL,
  group_id UUID NOT NULL,
  url text NOT NULL,
  type varchar(64) NOT NULL,
  status boolean NOT NULL,
  created date NOT NULL,
  updated date NOT NULL,
  CONSTRAINT assemblies_group_id FOREIGN KEY(group_id) REFERENCES groups(id)
);

CREATE UNIQUE INDEX assemblies_id ON assemblies (id);
CREATE INDEX assemblies_name ON assemblies (url);

CREATE TABLE relations_user_assembly (
  user_id UUID NOT NULL,
  assembly_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_assembly_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_assembly_assembly_id FOREIGN KEY(assembly_id) REFERENCES assemblies(id)
);

CREATE UNIQUE INDEX relations_user_assembly_assembly_id_i ON relations_user_assembly (assembly_id);

INSERT INTO users (
  id, 
  email, 
  name, 
  surname, 
  created, 
  updated
) VALUES (
  uuid_generate_v4(), 
  pgp_sym_encrypt('stanim857@gmail.com','!qazSymKeyXsw2'),
  pgp_sym_encrypt('Stas','!qazSymKeyXsw2'), 
  pgp_sym_encrypt('Morozov','!qazSymKeyXsw2'), 
  now(), 
  now()
);