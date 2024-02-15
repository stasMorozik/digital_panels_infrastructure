CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;


DROP INDEX confirmation_codes_needle;
DROP TABLE confirmation_codes;

DROP INDEX users_id;
DROP INDEX users_email;
DROP TABLE users;

DROP TABLE relations_user_content;
DROP TABLE contents;

DROP TABLE relations_user_file;
DROP TABLE files;

DROP TABLE relations_user_playlist;
DROP TABLE playlists;

DROP TABLE relations_user_device;
DROP TABLE devices;

DROP TABLE relations_user_group;
DROP TABLE groups;

CREATE TABLE users (
  id UUID NOT NULL,
  email text,
  name text,
  surname text,
  created date NOT NULL,
  updated date NOT NULL
);

CREATE UNIQUE INDEX users_id ON users (id);
CREATE UNIQUE INDEX users_email ON users (email);

CREATE TABLE confirmation_codes (
  needle text,
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
  size smallserial NOT NULL,
  created date NOT NULL,
  updated date NOT NULL
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

CREATE TABLE contents (
  id UUID NOT NULL,
  name varchar(64) NOT NULL,
  file_id UUID NOT NULL,
  playlist_id UUID NOT NULL,
  duration smallserial NOT NULL,
  serial_number  smallserial NOT NULL,
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

CREATE TABLE devices (
  id UUID NOT NULL,
  ip varchar(64) NOT NULL,
  latitude numeric NOT NULL,
  longitude numeric NOT NULL,
  desc varchar(256) NOT NULL,
  group_id UUID NOT NULL,
  created date NOT NULL,
  updated date NOT NULL,
  CONSTRAINT devices_group_id FOREIGN KEY(group_id) REFERENCES groups(id)
);

CREATE UNIQUE INDEX devices_id ON devices (id);
CREATE INDEX devices_ip ON devices (ip);
CREATE INDEX devices_desc ON devices (desc);

CREATE TABLE relations_user_device (
  user_id UUID NOT NULL,
  device_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_device_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_device_device_id FOREIGN KEY(device_id) REFERENCES devices(id)
);

CREATE INDEX relations_user_device_device_id_i ON relations_user_device (device_id);

CREATE TABLE groups (
  id UUID NOT NULL,
  name varchar(64) NOT NULL,
  sum smallserial NOT NULL,
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

CREATE TABLE playlists (
  id UUID NOT NULL,
  name varchar(64) NOT NULL,
  sum smallserial NOT NULL,
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

CREATE UNIQUE INDEX relations_user_playlist_playlist_id ON relations_user_playlist (playlist_id);

-- CREATE UNIQUE INDEX devices_id ON devices (id);
-- CREATE INDEX devices_ssh_host ON devices (ssh_host);
-- CREATE INDEX devices_address ON devices (address);
-- CREATE INDEX devices_longitude ON devices (longitude);
-- CREATE INDEX devices_latitude ON devices (latitude);

-- CREATE TABLE relations_user_device (
--   user_id UUID NOT NULL,
--   device_id UUID NOT NULL,
--   created date NOT NULL DEFAULT CURRENT_DATE,
--   updated date NOT NULL DEFAULT CURRENT_DATE,
--   CONSTRAINT relations_user_device_user_id FOREIGN KEY(user_id) REFERENCES users(id),
--   CONSTRAINT relations_user_device_device_id FOREIGN KEY(device_id) REFERENCES devices(id)
-- );

-- CREATE UNIQUE INDEX relations_user_device_device_id ON relations_user_device (device_id);

-- CREATE TABLE relations_playlist_device (
--   playlist_id UUID NOT NULL,
--   device_id UUID NOT NULL,
--   created date NOT NULL DEFAULT CURRENT_DATE,
--   updated date NOT NULL DEFAULT CURRENT_DATE,
--   CONSTRAINT relations_playlist_device_playlist_id FOREIGN KEY(playlist_id) REFERENCES playlists(id),
--   CONSTRAINT relations_playlist_device_device_id FOREIGN KEY(device_id) REFERENCES devices(id)
-- );

-- CREATE UNIQUE INDEX relations_playlist_device_device_id ON relations_playlist_device (device_id);

-- INSERT INTO users (
--   id, 
--   email, 
--   name, 
--   surname, 
--   created, 
--   updated
-- ) VALUES (
--   uuid_generate_v4(), 
--   'stasmoriniv@gmail.com', 
--   'admin', 
--   'root', 
--   now(), 
--   now()
-- );