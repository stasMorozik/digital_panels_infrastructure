CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

DROP INDEX confirmation_codes_needle;
DROP TABLE confirmation_codes;

DROP INDEX relations_user_playlist_playlist_id;
DROP TABLE relations_user_playlist;

DROP INDEX relations_user_device_device_id;
DROP TABLE relations_user_device;

DROP INDEX relations_playlist_device_device_id;
DROP TABLE relations_playlist_device;

DROP INDEX devices_id;
DROP INDEX devices_ssh_host;
DROP INDEX devices_address;
DROP INDEX devices_longitude;
DROP INDEX devices_latitude;
DROP TABLE devices;

DROP INDEX playlists_id;
DROP INDEX playlists_name;
DROP TABLE playlists;

DROP INDEX users_id;
DROP INDEX users_email;
DROP TABLE users;

CREATE TABLE users (
  id UUID NOT NULL,
  email varchar(64) NOT NULL,
  name varchar(32) NOT NULL,
  surname varchar(32) NOT NULL,
  created date NOT NULL,
  updated date NOT NULL
);

CREATE UNIQUE INDEX users_id ON users (id);
CREATE UNIQUE INDEX users_email ON users (email);

CREATE TABLE confirmation_codes (
  needle varchar(64) NOT NULL,
  code smallint NOT NULL,
  confirmed boolean NOT NULL,
  created integer NOT NULL
);

CREATE UNIQUE INDEX confirmation_codes_needle ON confirmation_codes (needle);

CREATE TABLE playlists (
  id UUID NOT NULL,
  name varchar(128) NOT NULL,
  contents json NOT NULL,
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

CREATE TABLE devices (
  id UUID NOT NULL,
  ssh_port serial NOT NULL,
  ssh_host varchar(16) NOT NULL,
  ssh_user varchar(16) NOT NULL,
  ssh_password varchar(16) NOT NULL,
  address varchar(256) NOT NULL,
  longitude numeric NOT NULL,
  latitude numeric NOT NULL,
  is_active boolean NOT NULL,
  created date NOT NULL,
  updated date NOT NULL
);

CREATE UNIQUE INDEX devices_id ON devices (id);
CREATE INDEX devices_ssh_host ON devices (ssh_host);
CREATE INDEX devices_address ON devices (address);
CREATE INDEX devices_longitude ON devices (longitude);
CREATE INDEX devices_latitude ON devices (latitude);

CREATE TABLE relations_user_device (
  user_id UUID NOT NULL,
  device_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_user_device_user_id FOREIGN KEY(user_id) REFERENCES users(id),
  CONSTRAINT relations_user_device_device_id FOREIGN KEY(device_id) REFERENCES devices(id)
);

CREATE UNIQUE INDEX relations_user_device_device_id ON relations_user_device (device_id);

CREATE TABLE relations_playlist_device (
  playlist_id UUID NOT NULL,
  device_id UUID NOT NULL,
  created date NOT NULL DEFAULT CURRENT_DATE,
  updated date NOT NULL DEFAULT CURRENT_DATE,
  CONSTRAINT relations_playlist_device_playlist_id FOREIGN KEY(playlist_id) REFERENCES playlists(id),
  CONSTRAINT relations_playlist_device_device_id FOREIGN KEY(device_id) REFERENCES devices(id)
);

CREATE UNIQUE INDEX relations_playlist_device_device_id ON relations_playlist_device (device_id);

INSERT INTO users (
  id, 
  email, 
  name, 
  surname, 
  created, 
  updated
) VALUES (
  uuid_generate_v4(), 
  'stasmoriniv@gmail.com', 
  'admin', 
  'root', 
  now(), 
  now()
);