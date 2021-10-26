--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4 (Debian 13.4-0+deb11u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sqitch; Type: SCHEMA; Schema: -; Owner: ochalet
--

CREATE SCHEMA sqitch;


ALTER SCHEMA sqitch OWNER TO ochalet;

--
-- Name: SCHEMA sqitch; Type: COMMENT; Schema: -; Owner: ochalet
--

COMMENT ON SCHEMA sqitch IS 'Sqitch database deployment metadata v1.1.';


--
-- Name: new_booking(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.new_booking(myrecord json) RETURNS integer
    LANGUAGE sql STRICT
    AS $$
	INSERT INTO "booking" ("reservation_start", "reservation_end", "offer_id", "user_id")
	VALUES (
		(myRecord->>'reservation_start')::timestamptz,
		(myRecord->>'reservation_end')::timestamptz,
		(myRecord->>'offer_id')::int,
		(myRecord->>'user_id')::int
	) RETURNING id
$$;


ALTER FUNCTION public.new_booking(myrecord json) OWNER TO ochalet;

--
-- Name: new_comment(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.new_comment(myrecord json) RETURNS integer
    LANGUAGE sql STRICT
    AS $$
	INSERT INTO "comment" ("body", "note", "offer_id", "user_id")
	VALUES (
		myRecord->>'body',
		(myRecord->>'note')::int,
		(myRecord->>'offer_id')::int,
		(myRecord->>'user_id')::int
	) RETURNING id
$$;


ALTER FUNCTION public.new_comment(myrecord json) OWNER TO ochalet;

--
-- Name: new_message(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.new_message(myrecord json) RETURNS integer
    LANGUAGE sql STRICT
    AS $$
	INSERT INTO "message" ("reservation_start", "reservation_end", "body", "offer_id", "user_id")
	VALUES (
		(myRecord->>'reservation_start')::timestamptz,
		(myRecord->>'reservation_end')::timestamptz,
		myRecord->>'body',
		(myRecord->>'offer_id')::int,
		(myRecord->>'user_id')::int
	) RETURNING id
$$;


ALTER FUNCTION public.new_message(myrecord json) OWNER TO ochalet;

--
-- Name: new_offer(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.new_offer(myrecord json) RETURNS integer
    LANGUAGE sql STRICT
    AS $$
	INSERT INTO "offer" ("title", "body", "zip_code", "city_name", "country", "street_name", "street_number", "price_ht", "tax", "main_picture", "galery_picture_1", "galery_picture_2", "galery_picture_3", "galery_picture_4", "galery_picture_5", "location_id")
	VALUES (
		myRecord->>'title',
		myRecord->>'body',
		myRecord->>'zip_code',
		myRecord->>'city_name',
		myRecord->>'country',
		myRecord->>'street_name',
		myRecord->>'street_number',
		(myRecord->>'price_ht')::int,
		(myRecord->>'tax')::int,
		myRecord->>'main_picture',
		myRecord->>'galery_picture_1',
		myRecord->>'galery_picture_2',
		myRecord->>'galery_picture_3',
		myRecord->>'galery_picture_4',
		myRecord->>'galery_picture_5',
        (myRecord->>'location_id')::int
	) RETURNING id
$$;


ALTER FUNCTION public.new_offer(myrecord json) OWNER TO ochalet;

--
-- Name: new_user(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.new_user(myrecord json) RETURNS integer
    LANGUAGE sql STRICT
    AS $$
	INSERT INTO "user" ("firstname", "lastname", "email", "password")
	VALUES (
		myRecord->>'firstname',
		myRecord->>'lastname',
		myRecord->>'email',
		myRecord->>'password'
	) RETURNING id
$$;


ALTER FUNCTION public.new_user(myrecord json) OWNER TO ochalet;

--
-- Name: update_booking(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.update_booking(json) RETURNS void
    LANGUAGE sql STRICT
    AS $_$
	UPDATE "booking" SET
		reservation_start=($1->>'reservation_start')::timestamptz,
		reservation_end=($1->>'reservation_end')::timestamptz,
        message=$1->>'message',
		reservation_status=($1->>'reservation_status')::boolean,
		offer_id=($1->>'offer_id')::int,
		user_id=($1->>'user_id')::int
	WHERE id=($1->>'id')::int;
$_$;


ALTER FUNCTION public.update_booking(json) OWNER TO ochalet;

--
-- Name: update_comment(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.update_comment(json) RETURNS void
    LANGUAGE sql STRICT
    AS $_$
	UPDATE "comment" SET
		body=$1->>'body',
        note=($1->>'note')::int,
		offer_id=($1->>'offer_id')::int,
		user_id=($1->>'user_id')::int
	WHERE id=($1->>'id')::int;
$_$;


ALTER FUNCTION public.update_comment(json) OWNER TO ochalet;

--
-- Name: update_message(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.update_message(json) RETURNS void
    LANGUAGE sql STRICT
    AS $_$
	UPDATE "message" SET
		reservation_start=($1->>'reservation_start')::timestamptz,
		reservation_end=($1->>'reservation_end')::timestamptz,
        nb_persons=($1->>'nb_persons')::int,
		body=$1->>'body',
		message_status=($1->>'message_status')::boolean,
		offer_id=($1->>'offer_id')::int,
		user_id=($1->>'user_id')::int
	WHERE id=($1->>'id')::int;
$_$;


ALTER FUNCTION public.update_message(json) OWNER TO ochalet;

--
-- Name: update_offer(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.update_offer(json) RETURNS void
    LANGUAGE sql STRICT
    AS $_$
	UPDATE "offer" SET
		title=$1->>'title',
		body=$1->>'body',
		zip_code=$1->>'zip_code',
		city_name=$1->>'city_name',
		country=$1->>'country',
		street_name=$1->>'street_name',
		street_number=$1->>'street_number',
		latitude=$1->>'latitude',
		longitude=$1->>'longitude',
		price_ht=($1->>'price_ht')::int,
		tax=($1->>'tax')::int,
		main_picture=$1->>'main_picture',
		galery_picture_1=$1->>'galery_picture_1',
		galery_picture_2=$1->>'galery_picture_2',
		galery_picture_3=$1->>'galery_picture_3',
		galery_picture_4=$1->>'galery_picture_4',
		galery_picture_5=$1->>'galery_picture_5',
        location_id=($1->>'location_id')::int,
        offer_status=($1->>'offer_status')::boolean
	WHERE id=($1->>'id')::int;
$_$;


ALTER FUNCTION public.update_offer(json) OWNER TO ochalet;

--
-- Name: update_user(json); Type: FUNCTION; Schema: public; Owner: ochalet
--

CREATE FUNCTION public.update_user(json) RETURNS void
    LANGUAGE sql STRICT
    AS $_$
	UPDATE "user" SET
		firstname=$1->>'firstname',
		lastname=$1->>'lastname',
		email=$1->>'email',
		phone=$1->>'phone',
		birth_date=($1->>'birth_date')::timestamptz,
		zip_code=$1->>'zip_code',
		city_name=$1->>'city_name',
		country=$1->>'country',
		street_name=$1->>'street_name',
		street_number=$1->>'street_number',
		password=$1->>'password'
	WHERE id=($1->>'id')::int;
$_$;


ALTER FUNCTION public.update_user(json) OWNER TO ochalet;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: booking; Type: TABLE; Schema: public; Owner: ochalet
--

CREATE TABLE public.booking (
    id integer NOT NULL,
    reservation_start timestamp with time zone NOT NULL,
    reservation_end timestamp with time zone NOT NULL,
    reservation_status boolean DEFAULT false NOT NULL,
    message text,
    user_id integer NOT NULL,
    offer_id integer NOT NULL
);


ALTER TABLE public.booking OWNER TO ochalet;

--
-- Name: booking_id_seq; Type: SEQUENCE; Schema: public; Owner: ochalet
--

ALTER TABLE public.booking ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.booking_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: comment; Type: TABLE; Schema: public; Owner: ochalet
--

CREATE TABLE public.comment (
    id integer NOT NULL,
    body text NOT NULL,
    note integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL,
    offer_id integer NOT NULL
);


ALTER TABLE public.comment OWNER TO ochalet;

--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: public; Owner: ochalet
--

ALTER TABLE public.comment ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: location; Type: TABLE; Schema: public; Owner: ochalet
--

CREATE TABLE public.location (
    id integer NOT NULL,
    name text NOT NULL,
    picture text NOT NULL
);


ALTER TABLE public.location OWNER TO ochalet;

--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: ochalet
--

ALTER TABLE public.location ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: message; Type: TABLE; Schema: public; Owner: ochalet
--

CREATE TABLE public.message (
    id integer NOT NULL,
    reservation_start timestamp with time zone,
    reservation_end timestamp with time zone,
    nb_persons integer,
    body text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    message_status boolean DEFAULT true NOT NULL,
    offer_id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.message OWNER TO ochalet;

--
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: ochalet
--

ALTER TABLE public.message ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: offer; Type: TABLE; Schema: public; Owner: ochalet
--

CREATE TABLE public.offer (
    id integer NOT NULL,
    title text NOT NULL,
    body text NOT NULL,
    zip_code text NOT NULL,
    city_name text NOT NULL,
    country text NOT NULL,
    street_name text NOT NULL,
    street_number text NOT NULL,
    latitude text,
    longitude text,
    price_ht integer NOT NULL,
    tax integer NOT NULL,
    main_picture text NOT NULL,
    galery_picture_1 text,
    galery_picture_2 text,
    galery_picture_3 text,
    galery_picture_4 text,
    galery_picture_5 text,
    offer_status boolean DEFAULT false NOT NULL,
    location_id integer NOT NULL
);


ALTER TABLE public.offer OWNER TO ochalet;

--
-- Name: offer_id_seq; Type: SEQUENCE; Schema: public; Owner: ochalet
--

ALTER TABLE public.offer ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.offer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: user; Type: TABLE; Schema: public; Owner: ochalet
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL,
    email text NOT NULL,
    phone text,
    birth_date timestamp with time zone,
    zip_code text,
    city_name text,
    country text,
    street_name text,
    street_number text,
    password text NOT NULL,
    role text DEFAULT 'user'::text NOT NULL
);


ALTER TABLE public."user" OWNER TO ochalet;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: ochalet
--

ALTER TABLE public."user" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: changes; Type: TABLE; Schema: sqitch; Owner: ochalet
--

CREATE TABLE sqitch.changes (
    change_id text NOT NULL,
    script_hash text,
    change text NOT NULL,
    project text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL
);


ALTER TABLE sqitch.changes OWNER TO ochalet;

--
-- Name: TABLE changes; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON TABLE sqitch.changes IS 'Tracks the changes currently deployed to the database.';


--
-- Name: COLUMN changes.change_id; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.change_id IS 'Change primary key.';


--
-- Name: COLUMN changes.script_hash; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.script_hash IS 'Deploy script SHA-1 hash.';


--
-- Name: COLUMN changes.change; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.change IS 'Name of a deployed change.';


--
-- Name: COLUMN changes.project; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.project IS 'Name of the Sqitch project to which the change belongs.';


--
-- Name: COLUMN changes.note; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.note IS 'Description of the change.';


--
-- Name: COLUMN changes.committed_at; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.committed_at IS 'Date the change was deployed.';


--
-- Name: COLUMN changes.committer_name; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.committer_name IS 'Name of the user who deployed the change.';


--
-- Name: COLUMN changes.committer_email; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.committer_email IS 'Email address of the user who deployed the change.';


--
-- Name: COLUMN changes.planned_at; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.planned_at IS 'Date the change was added to the plan.';


--
-- Name: COLUMN changes.planner_name; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.planner_name IS 'Name of the user who planed the change.';


--
-- Name: COLUMN changes.planner_email; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.changes.planner_email IS 'Email address of the user who planned the change.';


--
-- Name: dependencies; Type: TABLE; Schema: sqitch; Owner: ochalet
--

CREATE TABLE sqitch.dependencies (
    change_id text NOT NULL,
    type text NOT NULL,
    dependency text NOT NULL,
    dependency_id text,
    CONSTRAINT dependencies_check CHECK ((((type = 'require'::text) AND (dependency_id IS NOT NULL)) OR ((type = 'conflict'::text) AND (dependency_id IS NULL))))
);


ALTER TABLE sqitch.dependencies OWNER TO ochalet;

--
-- Name: TABLE dependencies; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON TABLE sqitch.dependencies IS 'Tracks the currently satisfied dependencies.';


--
-- Name: COLUMN dependencies.change_id; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.dependencies.change_id IS 'ID of the depending change.';


--
-- Name: COLUMN dependencies.type; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.dependencies.type IS 'Type of dependency.';


--
-- Name: COLUMN dependencies.dependency; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.dependencies.dependency IS 'Dependency name.';


--
-- Name: COLUMN dependencies.dependency_id; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.dependencies.dependency_id IS 'Change ID the dependency resolves to.';


--
-- Name: events; Type: TABLE; Schema: sqitch; Owner: ochalet
--

CREATE TABLE sqitch.events (
    event text NOT NULL,
    change_id text NOT NULL,
    change text NOT NULL,
    project text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    requires text[] DEFAULT '{}'::text[] NOT NULL,
    conflicts text[] DEFAULT '{}'::text[] NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL,
    CONSTRAINT events_event_check CHECK ((event = ANY (ARRAY['deploy'::text, 'revert'::text, 'fail'::text, 'merge'::text])))
);


ALTER TABLE sqitch.events OWNER TO ochalet;

--
-- Name: TABLE events; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON TABLE sqitch.events IS 'Contains full history of all deployment events.';


--
-- Name: COLUMN events.event; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.event IS 'Type of event.';


--
-- Name: COLUMN events.change_id; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.change_id IS 'Change ID.';


--
-- Name: COLUMN events.change; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.change IS 'Change name.';


--
-- Name: COLUMN events.project; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.project IS 'Name of the Sqitch project to which the change belongs.';


--
-- Name: COLUMN events.note; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.note IS 'Description of the change.';


--
-- Name: COLUMN events.requires; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.requires IS 'Array of the names of required changes.';


--
-- Name: COLUMN events.conflicts; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.conflicts IS 'Array of the names of conflicting changes.';


--
-- Name: COLUMN events.tags; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.tags IS 'Tags associated with the change.';


--
-- Name: COLUMN events.committed_at; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.committed_at IS 'Date the event was committed.';


--
-- Name: COLUMN events.committer_name; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.committer_name IS 'Name of the user who committed the event.';


--
-- Name: COLUMN events.committer_email; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.committer_email IS 'Email address of the user who committed the event.';


--
-- Name: COLUMN events.planned_at; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.planned_at IS 'Date the event was added to the plan.';


--
-- Name: COLUMN events.planner_name; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.planner_name IS 'Name of the user who planed the change.';


--
-- Name: COLUMN events.planner_email; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.events.planner_email IS 'Email address of the user who plan planned the change.';


--
-- Name: projects; Type: TABLE; Schema: sqitch; Owner: ochalet
--

CREATE TABLE sqitch.projects (
    project text NOT NULL,
    uri text,
    created_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    creator_name text NOT NULL,
    creator_email text NOT NULL
);


ALTER TABLE sqitch.projects OWNER TO ochalet;

--
-- Name: TABLE projects; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON TABLE sqitch.projects IS 'Sqitch projects deployed to this database.';


--
-- Name: COLUMN projects.project; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.projects.project IS 'Unique Name of a project.';


--
-- Name: COLUMN projects.uri; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.projects.uri IS 'Optional project URI';


--
-- Name: COLUMN projects.created_at; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.projects.created_at IS 'Date the project was added to the database.';


--
-- Name: COLUMN projects.creator_name; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.projects.creator_name IS 'Name of the user who added the project.';


--
-- Name: COLUMN projects.creator_email; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.projects.creator_email IS 'Email address of the user who added the project.';


--
-- Name: releases; Type: TABLE; Schema: sqitch; Owner: ochalet
--

CREATE TABLE sqitch.releases (
    version real NOT NULL,
    installed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    installer_name text NOT NULL,
    installer_email text NOT NULL
);


ALTER TABLE sqitch.releases OWNER TO ochalet;

--
-- Name: TABLE releases; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON TABLE sqitch.releases IS 'Sqitch registry releases.';


--
-- Name: COLUMN releases.version; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.releases.version IS 'Version of the Sqitch registry.';


--
-- Name: COLUMN releases.installed_at; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.releases.installed_at IS 'Date the registry release was installed.';


--
-- Name: COLUMN releases.installer_name; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.releases.installer_name IS 'Name of the user who installed the registry release.';


--
-- Name: COLUMN releases.installer_email; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.releases.installer_email IS 'Email address of the user who installed the registry release.';


--
-- Name: tags; Type: TABLE; Schema: sqitch; Owner: ochalet
--

CREATE TABLE sqitch.tags (
    tag_id text NOT NULL,
    tag text NOT NULL,
    project text NOT NULL,
    change_id text NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    committed_at timestamp with time zone DEFAULT clock_timestamp() NOT NULL,
    committer_name text NOT NULL,
    committer_email text NOT NULL,
    planned_at timestamp with time zone NOT NULL,
    planner_name text NOT NULL,
    planner_email text NOT NULL
);


ALTER TABLE sqitch.tags OWNER TO ochalet;

--
-- Name: TABLE tags; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON TABLE sqitch.tags IS 'Tracks the tags currently applied to the database.';


--
-- Name: COLUMN tags.tag_id; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.tag_id IS 'Tag primary key.';


--
-- Name: COLUMN tags.tag; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.tag IS 'Project-unique tag name.';


--
-- Name: COLUMN tags.project; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.project IS 'Name of the Sqitch project to which the tag belongs.';


--
-- Name: COLUMN tags.change_id; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.change_id IS 'ID of last change deployed before the tag was applied.';


--
-- Name: COLUMN tags.note; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.note IS 'Description of the tag.';


--
-- Name: COLUMN tags.committed_at; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.committed_at IS 'Date the tag was applied to the database.';


--
-- Name: COLUMN tags.committer_name; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.committer_name IS 'Name of the user who applied the tag.';


--
-- Name: COLUMN tags.committer_email; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.committer_email IS 'Email address of the user who applied the tag.';


--
-- Name: COLUMN tags.planned_at; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.planned_at IS 'Date the tag was added to the plan.';


--
-- Name: COLUMN tags.planner_name; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.planner_name IS 'Name of the user who planed the tag.';


--
-- Name: COLUMN tags.planner_email; Type: COMMENT; Schema: sqitch; Owner: ochalet
--

COMMENT ON COLUMN sqitch.tags.planner_email IS 'Email address of the user who planned the tag.';


--
-- Data for Name: booking; Type: TABLE DATA; Schema: public; Owner: ochalet
--

COPY public.booking (id, reservation_start, reservation_end, reservation_status, message, user_id, offer_id) FROM stdin;
26	2021-10-15 22:00:00+00	2021-10-22 22:00:00+00	f	\N	2	10
27	2021-11-12 23:00:00+00	2021-11-19 23:00:00+00	f	\N	2	10
28	2021-10-22 22:00:00+00	2021-10-29 22:00:00+00	f	\N	16	13
29	2021-10-22 22:00:00+00	2021-10-29 22:00:00+00	f	\N	2	8
30	2021-12-10 23:00:00+00	2021-12-17 23:00:00+00	f	\N	2	8
31	2021-10-22 22:00:00+00	2021-10-29 22:00:00+00	f	\N	11	14
32	2021-11-20 23:00:00+00	2021-11-26 23:00:00+00	f	\N	2	10
33	2021-11-14 23:00:00+00	2021-11-19 23:00:00+00	f	\N	16	14
34	2021-12-10 23:00:00+00	2021-12-17 23:00:00+00	f	\N	2	13
35	2021-12-10 23:00:00+00	2021-12-17 23:00:00+00	f	\N	2	10
36	2022-05-13 22:00:00+00	2022-05-20 22:00:00+00	f	\N	2	18
37	2022-03-11 23:00:00+00	2022-03-18 23:00:00+00	f	\N	2	18
38	2022-03-11 23:00:00+00	2022-03-18 23:00:00+00	f	\N	2	14
39	2021-10-13 22:00:00+00	2021-10-20 22:00:00+00	f	\N	8	7
40	2021-11-12 23:00:00+00	2021-11-19 23:00:00+00	f	\N	17	13
41	2021-11-05 23:00:00+00	2021-11-12 23:00:00+00	f	\N	17	11
42	2021-10-22 22:00:00+00	2021-10-29 22:00:00+00	f	\N	17	15
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: ochalet
--

COPY public.comment (id, body, note, created_at, user_id, offer_id) FROM stdin;
\.


--
-- Data for Name: location; Type: TABLE DATA; Schema: public; Owner: ochalet
--

COPY public.location (id, name, picture) FROM stdin;
1	Alpes du Nord	https://images.unsplash.com/photo-1597216394928-e6bc38109801?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2338&q=80
2	Alpes du Sud	https://images.unsplash.com/photo-1594629706083-67fd4ea4f0d5?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2340&q=80
3	Jura	https://images.unsplash.com/photo-1603445125995-6f47a1bfccf0?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2340&q=80
4	Massif Central	https://images.unsplash.com/photo-1603121494413-0d31fe0bfb1e?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2340&q=80
6	Vosges	https://images.unsplash.com/photo-1604782101560-b1cf32c445a8?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2340&q=80
5	Pyrénées	https://images.unsplash.com/photo-1538427144912-31de1ccb39f2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2340&q=80
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: ochalet
--

COPY public.message (id, reservation_start, reservation_end, nb_persons, body, created_at, message_status, offer_id, user_id) FROM stdin;
\.


--
-- Data for Name: offer; Type: TABLE DATA; Schema: public; Owner: ochalet
--

COPY public.offer (id, title, body, zip_code, city_name, country, street_name, street_number, latitude, longitude, price_ht, tax, main_picture, galery_picture_1, galery_picture_2, galery_picture_3, galery_picture_4, galery_picture_5, offer_status, location_id) FROM stdin;
7	La perle des bois	<h2>Description</h2><p>La perle des bois est un magnifique chalet situé à Gérardmer pouvant accueillir 14 personnes dans d'excellentes conditions de confort.</p><p>C'est le lieu idéal pour se ressourcer en famille, entre ami(e)s ou collègues..</p><p>Les prestations sont de qualités: jacuzzi 5 places, baby-foot, wifi,...</p><h2>Capacité d'accueil</h2><p>Entre 14 et 16 personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>5 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>2 salles de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux refusés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>Tv écran plat</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage compris</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Pas de petit déjeuner</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>Des guides de la région sont disponibles dans le chalet.</p><p>Le propriétaire se fera un plaisir de vous indiquer les randonnées les plus agréables et les coins les plus appréciés.</p>	88400	Gérardmer	France	impasse du Bas cellet	15	\N	\N	2500	20	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211701/quqrokktuzayk3uupha0.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211702/aoci3estfwdc0p5dgyzc.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211703/lpokioz5wuycasi5ovfe.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211704/uknhmmpgomcnsjqs5x5k.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211705/hmuyk0ba1c72tfkbxk1m.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211706/qsww8rrsg79chosltrfh.jpg	f	6
8	Le nid des marmottes	<h2>Description</h2><p>Magnifique chalet à deux pas des pistes de ski. Vous vous souviendrez longtemps de votre séjour !</p><h2>Capacité d'accueil</h2><p>Entre 10 et 12 personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>4 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>2 salles de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux autorisés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>Tv écran plat</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage en supplément</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Petit-déjeuner en supplément</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>Réduction de 10% sur votre forfait de remontées mécaniques avec le code <strong>NIDDESMARMOTTES21</strong></p>	88200	Remiremont	France	allée des hirondelles	165	\N	\N	2800	20	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211992/vbg7n04mdlftzmy9l2lz.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211993/zkp1jlqkbzulzmy0g1nx.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211994/ep6macmcy6o1ph8nfmql.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211995/uotinf7gmugbwdtiocsi.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211996/se5kupinkfyhdswqlbup.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634211997/pnscxmvrla30js7xgwyc.jpg	f	6
10	La retraite de l'aigle	<h2>Description</h2><p>Un coin de paradis dans les Vosges. Proche de la nature et de tout ce qu'elle a à offrir, ce chalet vous offrira la semaine de repos et de détente dont vous avez tant besoin.</p><h2>Capacité d'accueil</h2><p>Entre 4 et 6 personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>2 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>1 salle de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux autorisés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>-</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>-</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage compris</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Petit-déjeuner compris</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>Une ballade en chiens de traîneau vous sera proposée si vous réservez entre les mois de novembre et de février.</p>	88650	Anould	France	rue du Captain Aleks	84	\N	\N	2300	20	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634212608/m7zf6dtf8vxtabmq7hkz.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634212610/mrluxxv3kukduxyr1sva.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634212611/kfdodaf8ocpvd4tccyij.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634212612/wcxqosjnpu3sxrxvq4ao.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634212613/xspyfwia3dxm1pg9rkxg.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634212614/bgluo3jbctub9iyk5e2b.jpg	f	6
11	L'étoile des Alpes	<h2>Description</h2><p>Magnifique chalet moderne et épuré.&nbsp;</p><p>Profitez du calme et de la sérénité que vous offre ce havre de paix pour passer un moment hors du temps en famille ou entre amis.</p><h2>Capacité d'accueil</h2><p>Entre 1 et 12 personnes.</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>6 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>3 salles de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux refusés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>TV écran plat&nbsp;</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi disponible</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage compris</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Petit-déjeuner en supplément</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>Des prestations supplémentaires sont disponibles en supplément à la demande, comme par exemple la présence d'un chef pour vos repas, des masseurs, des professeurs de yoga, des baby-sitters,…</p>	05240	Serre Chevalier	France	avenue de la neige	35	\N	\N	5000	20	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634213669/bpwmjtnjesmkdbicvica.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634213671/utfahvv237x3bqfaofsc.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634213672/ao57dwl2hisl20wfoyda.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634213673/amx2ncth86a0b3sqs8l8.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634213674/ocbesppun83avbdur25d.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634213676/tac2inu3cobipkl2pabb.jpg	f	2
12	Le flocon d'Isola	<h2>Description</h2><p>Venez profiter de ce magnifique chalet au pied de la station Isola 2000.&nbsp;</p><p>Rénové avec goût, il saura vous accueillir pour que vous passiez le meilleur des séjours.</p><h2>Capacité d'accueil</h2><p>Entre 1 et 6 &nbsp;personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>3 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>2 salles de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux autorisés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>TV écran plat</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi disponible</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage en supplément</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Petit-déjeuner en supplément</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>En réservant ce chalet vous obtiendrez une réduction de 20% à valoir sur la location du matériel de ski et une remise de 10% sur vos forfaits de remontées mécaniques.</p>	06420	Isola	France	avenue de la station	15	\N	\N	3500	20	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634214448/psdildpaerztcncltmvn.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634214450/adofp1rrdylmrhjuk2lj.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634214451/y23dcso4csgrzshdw3fz.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634214453/om8wjw1quhqepbpy9xwr.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634214455/o4eslq8ztxecd5gm5rwq.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634214456/f8svjxyskvi6wt7yewpy.jpg	f	2
13	Le triangle des Orres	<h2>Description</h2><p>A 5km de la célèbre station des Orres, venez profiter du charme de ce chalet à l'architecture atypique. Décoré avec goût et très lumineux.</p><h2>Capacité d'accueil</h2><p>Entre 1 et 4 personnes.</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>2 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>1 salle de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux autorisés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>TV écran plat</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi disponible</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage en supplément</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Petit-déjeuner en supplément?</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>Une navette vous amenant à la station passe tous les jours à 200 mètres du chalet, de 8h à 17h, une fois par heure sans interruption au cours de la journée.</p>	05200	Les Orres	France	chemin des sapins	51	\N	\N	3000	20	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215050/ddkudrehhgmzznaof2ur.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215051/tix5ebvmuzlw6em24l1m.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215053/twmtm0eqovks75xzoy1z.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215054/kvf7k1cwbmftsasmfozp.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215055/l6zflndogd2iv6a5toge.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215056/ii0x8bfae7bnttqprjhq.jpg	f	2
14	Mon petit coin de paradis	<h2>Description</h2><p>Super chalet proche de toute commodités tout en étant isolé en pleine nature ,venez respirer le grand air et partagé des moments conviviaux en famille ou entre amis</p><h2>Capacité d'accueil</h2><p>Entre 1 et 10 personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>5 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>2 salles de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux refusés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>Tv écran plat</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage compris</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Pas de petit déjeuner</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>Des guides de la région sont disponibles dans le chalet.</p><p>Le propriétaire se fera un plaisir de vous indiquer les randonnées les plus agréables et les coins les plus appréciés</p>	39400	Les Rousses	France	chemin de l'eden	1	\N	\N	1000	40	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215379/ixosngcahhmwj3p5czcv.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215380/bn0qr4utadeb1hotdpc7.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215381/bavnhhdndaclqms7xv0u.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215382/qwnejoknh90bipye7bis.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215382/h7h7t1jodimxzug1demo.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215384/ofo7ighc9p2uxdwh8jrt.jpg	f	3
15	L'authentique des bois	<h2>Description</h2><p>Idéalement situé, ce chalet au style authentique saura vous séduire par la chaleur rustique de sa décoration, mélangée à la modernité de ses équipements.</p><h2>Capacité d'accueil</h2><p>Entre 1 et 8 personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>4 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>2 salles de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux autorisés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>TV écran plat</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi disponible</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage en supplément</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Petit-déjeuner en supplément</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>Profitez de la situation géographique exceptionnelle du chalet pour profiter du domaine skiable de Vars et de Risoul.&nbsp;</p><p>En réservant ce chalet vous obtiendrez 15% de réduction sur vos forfaits de remontées mécaniques pour tout achat d'un forfait “deux stations”.</p>	05560	Vars	France	chemin des pistes	21	\N	\N	2900	20	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215710/e7jlfwn3qo01ewbvdzgo.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215711/txvtrfc0i2cmgfpwb970.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215712/mpfm0xu5bgryikfbjbu5.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215713/yaaoz4yyfhsdxmc8fcxl.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215714/e9uj1qyl7eboltifqu6k.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634215715/udhlpncn2m2lbxr8ismh.jpg	f	2
17	Chez Germain	<h2>Description</h2><p>[Venez découvrir la capitale de la pipe Saint-Claude et ses environs, dans un chalet moderne et tout confort ]</p><h2>Capacité d'accueil</h2><p>Entre 1 et 8 personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>[4]</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>[2]</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux refusés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>Tv écran plat</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage en supplément</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>non</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>Réduction de 10% sur votre forfait de remontées mécaniques avec le code PIPES39</p>	39200	Saint-Claude	France	route de la fournaise	666	\N	\N	1200	30	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634221356/fbd3hmoumz4ktytzizpz.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634221358/uglwdydjrfal4ya1hqiy.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634221359/tbvhszelvfnnxtzxvzai.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634221359/pdve4jam30iwrmmz8omx.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634221361/islksjzyim80sepf1lij.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634221362/qnuui12ryprom2u8z5dx.jpg	f	3
18	La Retraite du Hérisson	<h2>Description</h2><p>Venez vous détendre dans notre chalet ,unique dans le Jura. Proche de la nature et de tout ce qu'elle a à offrir, ce chalet vous offrira la semaine de repos et de détente dont vous avez tant besoin.</p><h2>Capacité d'accueil</h2><p>Entre 1 et 10 personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>5 chambres</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>3 salles de bain</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux autorisés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>Tv écran plat</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Wifi</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage compris</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Pas de petit-déjeuner</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>A 5 mn des pistes de ski de fond et du lac de Chalain ,vous pourrez notamment visiter non loin la cascade du hérisson ainsi que nos spécialités culinaire. Alors n'hésitez plus lancez vous à la découverte du jura . &nbsp;</p>	39130	Fontenu	France	Impasse du lac	39	\N	\N	1400	60	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634225513/k0auxiz3zfm6ikxkzwxu.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634225514/hk0oswxgsnsyveiltjcm.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634225515/v20ehrsflr21bjdr7bcd.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634225516/j0v1o7zbt3oau2hknoul.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634225517/yfv3zmujozfyz0nblcmx.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634225518/gaffx70fxfzsgtcb2d9j.jpg	f	3
19	Le typique Jurassien	<h2>Description</h2><p>[Envie de se rapprocher de la nature ? Nous vous proposons ce magnifique typique et atypique chalet jurassien ]</p><h2>Capacité d'accueil</h2><p>Entre 1 et 4 personnes</p><h2>Prestations</h2><figure class="table"><table><tbody><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/bed.png"></td><td>2 chambres&nbsp;</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/shower-and-tub.png"></td><td>&nbsp;salles de bain commune</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/dog.png"></td><td>Animaux autorisés</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/retro-tv.png"></td><td>Non</td></tr><tr><td><img src="https://img.icons8.com/glyph-neue/30/000000/wifi.png"></td><td>Non</td></tr><tr><td><img src="https://img.icons8.com/ios-filled/30/000000/housekeeping.png"></td><td>Ménage compris</td></tr><tr><td><img src="https://img.icons8.com/external-vitaliy-gorbachev-fill-vitaly-gorbachev/30/000000/external-croissant-fast-food-vitaliy-gorbachev-fill-vitaly-gorbachev.png"></td><td>Petit-déjeuner en supplément</td></tr></tbody></table></figure><h2>Informations complémentaires</h2><p>[Pour votre confort, notre magnifique chalet n'est ouvert qu' en été]</p>	39041	baume les messieurs	France	chemin des bonhommes	5	\N	\N	100	10	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634232692/xtzihrmpo6xhmrhsyquq.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634232693/x5p98rtfgmaysjvn51nm.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634232694/wuwuezseoqpr07p3kfak.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634232696/wtlphcegmofn7mx23ush.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634232697/zhhpniwu1y6vhcj3c10a.jpg	http://res.cloudinary.com/dudxvl1m3/image/upload/v1634232699/xuwdldiwth1sh65cxzmn.jpg	f	3
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: ochalet
--

COPY public."user" (id, firstname, lastname, email, phone, birth_date, zip_code, city_name, country, street_name, street_number, password, role) FROM stdin;
666	deletedUser	deleterUser	deletedUser	\N	\N	\N	\N	\N	\N	\N	deletedUser	user
7	Ali	Baba	ali@baba.fr	0123456789	1991-07-21 00:00:00+00	11000	Frime les Oies	France	rue de la neige	11	$2b$10$wb7Zjm1/SG53ZMHjXpWl2eJ6EzI2JGso4RAtyR2G63QFGKHgfsuL6	user
3	kross	kriss	kris@test.fr	\N	\N	\N	\N	\N	\N	\N	$2b$10$wybJJfPDhj/98pz63WOtK.eduKWUVQlG1KMlEGGGJmOxT13EVz0.S	user
1	Tom	Tomtom	tom@tom.fr	0102030406	\N	\N	\N	\N	\N	\N	$2b$10$uPaE4JVLRuVReWfzd7oURetW..5o6CEwwqkFsDFYklJwsdSeICcWC	admin
4	Benjamin	CHORON	benjamin@choron.com	\N	\N	\N	\N	\N	\N	\N	$2b$10$VL449WlT1k4Zd6xoRJMfnuMbODY7Jg.O0lFDGgUpSrcVpsybOW7aq	user
6	fer	luci	lucifer@test.fr	\N	\N	\N	\N	\N	\N	\N	$2b$10$xM4lIT46xBqjUAmR0KM.8u8Ds2Wib9WsykozF.vV2EbM2TRe6wXJy	user
10	francis	labrel	francis@test.fr	0623584666	\N	46000	sarbacanne	france	je sais pas	456	$2b$10$gCsFKRZhcfa/x5c8ZoM9WOeePr3gnW6h.zG5EHUxBpnYwF/j.98Na	user
5	Jean	Michel	jean@michel.com	0999999999	1922-12-01 00:00:00+00	99999	London	England	rue de l'API	999	$2b$10$t1Xo7OIs.oE3k.NJPFWkb.DH4kDSQzVW.G3PvMcZyti4EALmkvd8i	user
2	Benjamin	CHORON	benjamin@choron.fr	0352146588	1990-03-06 00:00:00+00	54222	DevCity	DevLand	allée des dev	12	$2b$10$BmN7gWq/grL8rusc9AD3I.W/OcEVvqNHhpxBVmJ1aCWM0fISWx3Vq	user
12	thibault	dupond	ghpduvb@gmail.com	\N	\N	\N	\N	\N	\N	\N	$2b$10$GuGtHamAa2mRo1bdOP/q3exU8MZjpXia3HE9NDxPYVoGatMdUC9hm	user
8	Vincent	PAYEN	payen.vincent@gmail.com	0102030405	\N	92500	Dev City	Dev Land	rue de l'API	15	$2b$10$.u6jmfUeLZ71L85Owp9BruxcNn2obWwxK/KaAkPzwdyToQMOA3gkW	user
13	thibault	dupond	dupondj587@gmail.com	0487757575	\N	93250	trouloulou	Afganistan	mohamed	6969	$2b$10$/62v0N3W5y5UnI2lifVJRO4A9ua3HQ5r6R5b14KDH9I3iQNQefdzW	admin
9	jerome	kara	jerome@gmail.com	0654842541	\N	75018	Paris	France	rue de la paix	15	$2b$10$17hk.jRPMM45bebnN5dntuZCRZbDJR5LHj1tHFkrvFOmgv5JU9vtq	user
11	Jean paul	Dupont	jp@dupont.com	0123456789	\N	11001	Frime les Oies	France	llllllfff	11	$2b$10$.Zm78h9KVUCuaIt/EmCNget1.kxcVPTFy6OYTEOFbt9UiHM2nikxG	admin
14	jerome	karabenli	jkarabenli@gmail.com	0658254580	\N	75018	ffff	france	jdjjd	jfjfjf	$2b$10$6g4KJqBwwp2NYDZUFGpcY.fS6WDt7qKlkVK3CY4EVjzg8aWYvswBW	user
15	kara	jerome	j@dev.com	\N	\N	\N	\N	\N	\N	\N	$2b$10$SzW1gTXltwnqNkUZo.cljOJZ3SBe3.NNEYKTmyQ7ZTD1Zg/MbJ0yi	user
16	Lol	Loli	loli@lol.fr	0123456789	\N	13100	Lyon	France	lala	21	$2b$10$HAsh48DJTg4f9vXmicNQq.C6By8oqnAGDsqQ2r3g4fgdmBo.g.kIq	user
17	Harry	Co	harry@co.fr	0123456780	1991-07-21 00:00:00+00	13110	Aix en Provence	France	rue des pistes	15	$2b$10$.JSFzsFQBS46AaERtppZDeom65Gz42NpfLqWmEaAeP6ZCmqM8G9hm	user
\.


--
-- Data for Name: changes; Type: TABLE DATA; Schema: sqitch; Owner: ochalet
--

COPY sqitch.changes (change_id, script_hash, change, project, note, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
9f3d8a2ba1c896277f75e92189284b34fe38d76e	1d074ba286a65b6fffd3465a98956889844cc8ef	init	ochalet	init db	2021-10-13 12:16:53.709045+00	root	root@2c901bc601b9	2021-09-21 13:42:44+00	jerome	jkarabenli.occlock@gmail.com
88c9acc07f7019f5e8d5eb14245300538c51f7ad	9f4510035ce7c0d3fc327e9096ae06f59430753f	user_function	ochalet	create user functions	2021-10-13 12:16:53.793526+00	root	root@2c901bc601b9	2021-09-21 16:05:44+00	jerome	jkarabenli.occlock@gmail.com
0e1e885725a29f84776c4fb984bb107649226f92	75eab4da71eaa74d4b214a03c3c6d17c64425345	sql_create_update_functions	ochalet	create all sql functions for create and update	2021-10-13 12:16:53.865594+00	root	root@2c901bc601b9	2021-09-22 09:31:11+00	BenjCH	benjamin.choron@outlook.com
\.


--
-- Data for Name: dependencies; Type: TABLE DATA; Schema: sqitch; Owner: ochalet
--

COPY sqitch.dependencies (change_id, type, dependency, dependency_id) FROM stdin;
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: sqitch; Owner: ochalet
--

COPY sqitch.events (event, change_id, change, project, note, requires, conflicts, tags, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
deploy	9f3d8a2ba1c896277f75e92189284b34fe38d76e	init	ochalet	init db	{}	{}	{}	2021-10-13 12:16:53.711741+00	root	root@2c901bc601b9	2021-09-21 13:42:44+00	jerome	jkarabenli.occlock@gmail.com
deploy	88c9acc07f7019f5e8d5eb14245300538c51f7ad	user_function	ochalet	create user functions	{}	{}	{}	2021-10-13 12:16:53.794424+00	root	root@2c901bc601b9	2021-09-21 16:05:44+00	jerome	jkarabenli.occlock@gmail.com
deploy	0e1e885725a29f84776c4fb984bb107649226f92	sql_create_update_functions	ochalet	create all sql functions for create and update	{}	{}	{}	2021-10-13 12:16:53.866458+00	root	root@2c901bc601b9	2021-09-22 09:31:11+00	BenjCH	benjamin.choron@outlook.com
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: sqitch; Owner: ochalet
--

COPY sqitch.projects (project, uri, created_at, creator_name, creator_email) FROM stdin;
ochalet	\N	2021-10-13 12:16:53.582835+00	root	root@2c901bc601b9
\.


--
-- Data for Name: releases; Type: TABLE DATA; Schema: sqitch; Owner: ochalet
--

COPY sqitch.releases (version, installed_at, installer_name, installer_email) FROM stdin;
1.1	2021-10-13 12:16:53.574088+00	root	root@2c901bc601b9
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: sqitch; Owner: ochalet
--

COPY sqitch.tags (tag_id, tag, project, change_id, note, committed_at, committer_name, committer_email, planned_at, planner_name, planner_email) FROM stdin;
\.


--
-- Name: booking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ochalet
--

SELECT pg_catalog.setval('public.booking_id_seq', 42, true);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ochalet
--

SELECT pg_catalog.setval('public.comment_id_seq', 1, false);


--
-- Name: location_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ochalet
--

SELECT pg_catalog.setval('public.location_id_seq', 12, true);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ochalet
--

SELECT pg_catalog.setval('public.message_id_seq', 1, false);


--
-- Name: offer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ochalet
--

SELECT pg_catalog.setval('public.offer_id_seq', 19, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ochalet
--

SELECT pg_catalog.setval('public.user_id_seq', 17, true);


--
-- Name: booking booking_pkey; Type: CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_pkey PRIMARY KEY (id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: location location_pkey; Type: CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.location
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: offer offer_pkey; Type: CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.offer
    ADD CONSTRAINT offer_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: changes changes_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_pkey PRIMARY KEY (change_id);


--
-- Name: changes changes_project_script_hash_key; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_project_script_hash_key UNIQUE (project, script_hash);


--
-- Name: dependencies dependencies_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_pkey PRIMARY KEY (change_id, dependency);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (change_id, committed_at);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (project);


--
-- Name: projects projects_uri_key; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.projects
    ADD CONSTRAINT projects_uri_key UNIQUE (uri);


--
-- Name: releases releases_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.releases
    ADD CONSTRAINT releases_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (tag_id);


--
-- Name: tags tags_project_tag_key; Type: CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_project_tag_key UNIQUE (project, tag);


--
-- Name: booking booking_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offer(id);


--
-- Name: booking booking_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.booking
    ADD CONSTRAINT booking_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: comment comment_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offer(id);


--
-- Name: comment comment_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: message message_offer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_offer_id_fkey FOREIGN KEY (offer_id) REFERENCES public.offer(id);


--
-- Name: message message_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: offer offer_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: ochalet
--

ALTER TABLE ONLY public.offer
    ADD CONSTRAINT offer_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.location(id);


--
-- Name: changes changes_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.changes
    ADD CONSTRAINT changes_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- Name: dependencies dependencies_change_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_change_id_fkey FOREIGN KEY (change_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: dependencies dependencies_dependency_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.dependencies
    ADD CONSTRAINT dependencies_dependency_id_fkey FOREIGN KEY (dependency_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE;


--
-- Name: events events_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.events
    ADD CONSTRAINT events_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- Name: tags tags_change_id_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_change_id_fkey FOREIGN KEY (change_id) REFERENCES sqitch.changes(change_id) ON UPDATE CASCADE;


--
-- Name: tags tags_project_fkey; Type: FK CONSTRAINT; Schema: sqitch; Owner: ochalet
--

ALTER TABLE ONLY sqitch.tags
    ADD CONSTRAINT tags_project_fkey FOREIGN KEY (project) REFERENCES sqitch.projects(project) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

