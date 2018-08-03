--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4 (Debian 10.4-2.pgdg90+1)
-- Dumped by pg_dump version 10.4 (Ubuntu 10.4-0ubuntu0.18.04)


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;
--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: date_format(timestamp without time zone, text); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.date_format(timestamp without time zone, text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
      DECLARE
        i int := 1;
        temp text := '';
        c text;
        n text;
        res text;
      BEGIN
        WHILE i <= pg_catalog.length($2) LOOP
          -- Look at current character
          c := SUBSTRING ($2 FROM i FOR 1);
          -- If it's a '%' and not the last character then process it as a placeholder
          IF c = '%' AND i != pg_catalog.length($2) THEN
            n := SUBSTRING ($2 FROM (i + 1) FOR 1);
            SELECT INTO res CASE
              WHEN n = 'a' THEN pg_catalog.to_char($1, 'Dy')
              WHEN n = 'b' THEN pg_catalog.to_char($1, 'Mon')
              WHEN n = 'c' THEN pg_catalog.to_char($1, 'FMMM')
              WHEN n = 'D' THEN pg_catalog.to_char($1, 'FMDDth')
              WHEN n = 'd' THEN pg_catalog.to_char($1, 'DD')
              WHEN n = 'e' THEN pg_catalog.to_char($1, 'FMDD')
              WHEN n = 'f' THEN pg_catalog.to_char($1, 'US')
              WHEN n = 'H' THEN pg_catalog.to_char($1, 'HH24')
              WHEN n = 'h' THEN pg_catalog.to_char($1, 'HH12')
              WHEN n = 'I' THEN pg_catalog.to_char($1, 'HH12')
              WHEN n = 'i' THEN pg_catalog.to_char($1, 'MI')
              WHEN n = 'j' THEN pg_catalog.to_char($1, 'DDD')
              WHEN n = 'k' THEN pg_catalog.to_char($1, 'FMHH24')
              WHEN n = 'l' THEN pg_catalog.to_char($1, 'FMHH12')
              WHEN n = 'M' THEN pg_catalog.to_char($1, 'FMMonth')
              WHEN n = 'm' THEN pg_catalog.to_char($1, 'MM')
              WHEN n = 'p' THEN pg_catalog.to_char($1, 'AM')
              WHEN n = 'r' THEN pg_catalog.to_char($1, 'HH12:MI:SS AM')
              WHEN n = 'S' THEN pg_catalog.to_char($1, 'SS')
              WHEN n = 's' THEN pg_catalog.to_char($1, 'SS')
              WHEN n = 'T' THEN pg_catalog.to_char($1, 'HH24:MI:SS')
              WHEN n = 'U' THEN pg_catalog.to_char($1, '?')
              WHEN n = 'u' THEN pg_catalog.to_char($1, '?')
              WHEN n = 'V' THEN pg_catalog.to_char($1, '?')
              WHEN n = 'v' THEN pg_catalog.to_char($1, '?')
              WHEN n = 'W' THEN pg_catalog.to_char($1, 'FMDay')
              WHEN n = 'w' THEN EXTRACT(DOW FROM $1)::text
              WHEN n = 'X' THEN pg_catalog.to_char($1, '?')
              WHEN n = 'x' THEN pg_catalog.to_char($1, '?')
              WHEN n = 'Y' THEN pg_catalog.to_char($1, 'YYYY')
              WHEN n = 'y' THEN pg_catalog.to_char($1, 'YY')
              WHEN n = '%' THEN pg_catalog.to_char($1, '%')
              ELSE NULL
            END;
            temp := temp operator(pg_catalog.||) res;
            i := i + 2;
          ELSE
            -- Otherwise just append the character to the string
            temp = temp operator(pg_catalog.||) c;
            i := i + 1;
          END IF;
        END LOOP;
        RETURN temp;
      END
    $_$;


ALTER FUNCTION public.date_format(timestamp without time zone, text) OWNER TO admin;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: wolf_cron; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_cron (
    id integer NOT NULL,
    lastrun text
);


ALTER TABLE public.wolf_cron OWNER TO admin;

--
-- Name: wolf_cron_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_cron_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_cron_id_seq OWNER TO admin;

--
-- Name: wolf_cron_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_cron_id_seq OWNED BY public.wolf_cron.id;


--
-- Name: wolf_layout; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_layout (
    id integer NOT NULL,
    name character varying(100) DEFAULT NULL::character varying,
    content_type character varying(80) DEFAULT NULL::character varying,
    content text,
    created_on timestamp without time zone,
    updated_on timestamp without time zone,
    created_by_id integer,
    updated_by_id integer,
    "position" integer
);


ALTER TABLE public.wolf_layout OWNER TO admin;

--
-- Name: wolf_layout_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_layout_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_layout_id_seq OWNER TO admin;

--
-- Name: wolf_layout_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_layout_id_seq OWNED BY public.wolf_layout.id;


--
-- Name: wolf_page; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_page (
    id integer NOT NULL,
    title character varying(255) DEFAULT NULL::character varying,
    slug character varying(100) DEFAULT ''::character varying NOT NULL,
    breadcrumb character varying(160) DEFAULT NULL::character varying,
    keywords character varying(255) DEFAULT NULL::character varying,
    description text,
    parent_id integer,
    layout_id integer,
    behavior_id character varying(25) DEFAULT ''::character varying NOT NULL,
    status_id integer DEFAULT 100 NOT NULL,
    created_on timestamp without time zone,
    published_on timestamp without time zone,
    valid_until timestamp without time zone,
    updated_on timestamp without time zone,
    created_by_id integer,
    updated_by_id integer,
    "position" integer DEFAULT 0,
    is_protected smallint DEFAULT '0'::smallint NOT NULL,
    needs_login smallint DEFAULT '2'::smallint NOT NULL
);


ALTER TABLE public.wolf_page OWNER TO admin;

--
-- Name: wolf_page_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_page_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_page_id_seq OWNER TO admin;

--
-- Name: wolf_page_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_page_id_seq OWNED BY public.wolf_page.id;


--
-- Name: wolf_page_part; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_page_part (
    id integer NOT NULL,
    name character varying(100) DEFAULT NULL::character varying,
    filter_id character varying(25) DEFAULT NULL::character varying,
    content text,
    content_html text,
    page_id integer
);


ALTER TABLE public.wolf_page_part OWNER TO admin;

--
-- Name: wolf_page_part_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_page_part_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_page_part_id_seq OWNER TO admin;

--
-- Name: wolf_page_part_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_page_part_id_seq OWNED BY public.wolf_page_part.id;


--
-- Name: wolf_page_tag; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_page_tag (
    page_id integer NOT NULL,
    tag_id integer NOT NULL
);


ALTER TABLE public.wolf_page_tag OWNER TO admin;

--
-- Name: wolf_permission; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_permission (
    id integer NOT NULL,
    name character varying(25) NOT NULL
);


ALTER TABLE public.wolf_permission OWNER TO admin;

--
-- Name: wolf_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_permission_id_seq OWNER TO admin;

--
-- Name: wolf_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_permission_id_seq OWNED BY public.wolf_permission.id;


--
-- Name: wolf_plugin_settings; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_plugin_settings (
    plugin_id character varying(40) NOT NULL,
    name character varying(40) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.wolf_plugin_settings OWNER TO admin;

--
-- Name: wolf_role; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_role (
    id integer NOT NULL,
    name character varying(25) NOT NULL
);


ALTER TABLE public.wolf_role OWNER TO admin;

--
-- Name: wolf_role_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_role_id_seq OWNER TO admin;

--
-- Name: wolf_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_role_id_seq OWNED BY public.wolf_role.id;


--
-- Name: wolf_role_permission; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_role_permission (
    role_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.wolf_role_permission OWNER TO admin;

--
-- Name: wolf_secure_token; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_secure_token (
    id integer NOT NULL,
    username character varying(40) DEFAULT NULL::character varying,
    url character varying(255) DEFAULT NULL::character varying,
    "time" character varying(100) DEFAULT NULL::character varying
);


ALTER TABLE public.wolf_secure_token OWNER TO admin;

--
-- Name: wolf_secure_token_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_secure_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_secure_token_id_seq OWNER TO admin;

--
-- Name: wolf_secure_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_secure_token_id_seq OWNED BY public.wolf_secure_token.id;


--
-- Name: wolf_setting; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_setting (
    name character varying(40) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.wolf_setting OWNER TO admin;

--
-- Name: wolf_snippet; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_snippet (
    id integer NOT NULL,
    name character varying(100) DEFAULT ''::character varying NOT NULL,
    filter_id character varying(25) DEFAULT NULL::character varying,
    content text,
    content_html text,
    created_on timestamp without time zone,
    updated_on timestamp without time zone,
    created_by_id integer,
    updated_by_id integer,
    "position" integer
);


ALTER TABLE public.wolf_snippet OWNER TO admin;

--
-- Name: wolf_snippet_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_snippet_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_snippet_id_seq OWNER TO admin;

--
-- Name: wolf_snippet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_snippet_id_seq OWNED BY public.wolf_snippet.id;


--
-- Name: wolf_tag; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_tag (
    id integer NOT NULL,
    name character varying(40) NOT NULL,
    count integer NOT NULL
);


ALTER TABLE public.wolf_tag OWNER TO admin;

--
-- Name: wolf_tag_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_tag_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_tag_id_seq OWNER TO admin;

--
-- Name: wolf_tag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_tag_id_seq OWNED BY public.wolf_tag.id;


--
-- Name: wolf_user; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_user (
    id integer NOT NULL,
    name character varying(100) DEFAULT NULL::character varying,
    email character varying(255) DEFAULT NULL::character varying,
    username character varying(40) NOT NULL,
    password character varying(1024) DEFAULT NULL::character varying,
    salt character varying(1024) DEFAULT NULL::character varying,
    language character varying(40) DEFAULT NULL::character varying,
    last_login timestamp without time zone,
    last_failure timestamp without time zone,
    failure_count integer,
    created_on timestamp without time zone,
    updated_on timestamp without time zone,
    created_by_id integer,
    updated_by_id integer
);


ALTER TABLE public.wolf_user OWNER TO admin;

--
-- Name: wolf_user_id_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.wolf_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wolf_user_id_seq OWNER TO admin;

--
-- Name: wolf_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.wolf_user_id_seq OWNED BY public.wolf_user.id;


--
-- Name: wolf_user_role; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.wolf_user_role (
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE public.wolf_user_role OWNER TO admin;

--
-- Name: wolf_cron id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_cron ALTER COLUMN id SET DEFAULT nextval('public.wolf_cron_id_seq'::regclass);


--
-- Name: wolf_layout id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_layout ALTER COLUMN id SET DEFAULT nextval('public.wolf_layout_id_seq'::regclass);


--
-- Name: wolf_page id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_page ALTER COLUMN id SET DEFAULT nextval('public.wolf_page_id_seq'::regclass);


--
-- Name: wolf_page_part id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_page_part ALTER COLUMN id SET DEFAULT nextval('public.wolf_page_part_id_seq'::regclass);


--
-- Name: wolf_permission id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_permission ALTER COLUMN id SET DEFAULT nextval('public.wolf_permission_id_seq'::regclass);


--
-- Name: wolf_role id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_role ALTER COLUMN id SET DEFAULT nextval('public.wolf_role_id_seq'::regclass);


--
-- Name: wolf_secure_token id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_secure_token ALTER COLUMN id SET DEFAULT nextval('public.wolf_secure_token_id_seq'::regclass);


--
-- Name: wolf_snippet id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_snippet ALTER COLUMN id SET DEFAULT nextval('public.wolf_snippet_id_seq'::regclass);


--
-- Name: wolf_tag id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_tag ALTER COLUMN id SET DEFAULT nextval('public.wolf_tag_id_seq'::regclass);


--
-- Name: wolf_user id; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_user ALTER COLUMN id SET DEFAULT nextval('public.wolf_user_id_seq'::regclass);


--
-- Data for Name: wolf_cron; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_cron (id, lastrun) FROM stdin;
1	0
\.


--
-- Data for Name: wolf_layout; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_layout (id, name, content_type, content, created_on, updated_on, created_by_id, updated_by_id, "position") FROM stdin;
1	none	text/html	<?php echo $this->content(); ?>	2018-08-03 07:44:32	2018-08-03 07:44:33	1	1	\N
2	Wolf	text/html	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">\r\n<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-GB">\r\n\r\n<head>\r\n\t<title><?php echo $this->title(); ?></title>\r\n\r\n  <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />\r\n  <meta name="robots" content="index, follow" />\r\n  <meta name="description" content="<?php echo ($this->description() != '') ? $this->description() : 'Default description goes here'; ?>" />\r\n  <meta name="keywords" content="<?php echo ($this->keywords() != '') ? $this->keywords() : 'default, keywords, here'; ?>" />\r\n  <meta name="author" content="Author Name" />\r\n\r\n  <link rel="favourites icon" href="<?php echo THEMES_PATH; ?>simple/images/favicon.ico" />\r\n\r\n  <!-- Adapted from Matthew James Taylor's "Holy Grail 3 column liquid-layout" = http://bit.ly/ejfjq -->\r\n  <!-- No snippets used; but snippet blocks for header, secondary nav, and footer are indicated -->\r\n\r\n  <link rel="stylesheet" href="<?php echo THEMES_PATH; ?>wolf/screen.css" media="screen" type="text/css" />\r\n  <link rel="stylesheet" href="<?php echo THEMES_PATH; ?>wolf/print.css" media="print" type="text/css" />\r\n  <link rel="alternate" type="application/rss+xml" title="Wolf Default RSS Feed" href="<?php echo URL_PUBLIC.((USE_MOD_REWRITE)?'':'/?'); ?>rss.xml" />\r\n\r\n</head>\r\n<body>\r\n\r\n<!-- HEADER - COULD BE SNIPPET / START -->\r\n<div id="header">\r\n\t<h1><a href="<?php echo URL_PUBLIC; ?>">Wolf</a><span class="tagline">content management simplified</span></h1>\r\n</div><!-- / #header -->\r\n<div id="nav">\r\n\t<ul>\r\n      <li><a<?php echo url_match('/') ? ' class="current"': ''; ?> href="<?php echo URL_PUBLIC; ?>">Home</a></li>\r\n<?php foreach($this->find('/')->children() as $menu): ?>\r\n      <li><?php echo $menu->link($menu->title, (in_array($menu->slug, explode('/', $this->path())) ? ' class="current"': null)); ?></li>\r\n<?php endforeach; ?> \r\n\t</ul>\r\n</div><!-- / #nav -->\r\n<!-- HEADER / END -->\r\n\r\n<div id="colmask"><div id="colmid"><div id="colright"><!-- = outer nested divs -->\r\n\r\n\t<div id="col1wrap"><div id="col1pad"><!-- = inner/col1 nested divs -->\r\n\r\n\t\t<div id="col1">\r\n\t\t<!-- Column 1 start = main content -->\r\n\r\n<h2><?php echo $this->title(); ?></h2>\r\n\r\n  <?php echo $this->content(); ?> \r\n  <?php if ($this->hasContent('extended')) echo $this->content('extended'); ?> \r\n\r\n\t\t<!-- Column 1 end -->\r\n\t\t</div><!-- / #col1 -->\r\n\t\r\n\t<!-- end inner/col1 nested divs -->\r\n\t</div><!-- / #col1pad --></div><!-- / #col1wrap -->\r\n\r\n\t\t<div id="col2">\r\n\t\t<!-- Column 2 start = left/running sidebar -->\r\n\r\n  <?php echo $this->content('sidebar', true); ?> \r\n\r\n\t\t<!-- Column 2 end -->\r\n\t\t</div><!-- / #col2 -->\r\n\r\n\t\t<div id="col3">\r\n\t\t<!-- Column 3 start = right/secondary nav sidebar -->\r\n\r\n<!-- THIS CONDITIONAL NAVIGATION COULD GO INTO A SNIPPET / START -->\r\n<?php if ($this->level() > 0) { $slugs = explode('/', CURRENT_PATH); $parent = reset($slugs); $topPage = $this->find($parent); } ?>\r\n<?php if(isset($topPage) && $topPage != '' && $topPage != null) : ?>\r\n\r\n<?php if ($this->level() > 0) : ?>\r\n<?php if (count($topPage->children()) > 0 && $topPage->slug() != 'articles') : ?>\r\n<h2><?php echo $topPage->title(); ?> Menu</h2>\r\n<ul>\r\n<?php foreach ($topPage->children() as $subPage): ?>\r\n    <li><?php echo $subPage->link($subPage->title, (url_start_with($subPage->path()) ? ' class="current"': null)); ?></li>\r\n<?php endforeach; ?>\r\n</ul>\r\n<?php endif; ?>\r\n<?php endif; ?>\r\n<?php endif; ?>\r\n<!-- CONDITIONAL NAVIGATION / END -->\r\n\r\n\t\t<!-- Column 3 end -->\r\n\t\t</div><!-- / #col3 -->\r\n\r\n<!-- end outer nested divs -->\r\n</div><!-- / #colright --></div><!-- /colmid # --></div><!-- / #colmask -->\r\n\r\n<!-- FOOTER - COULD BE SNIPPET / START -->\r\n<div id="footer">\r\n\r\n  <p>&copy; Copyright <?php echo date('Y'); ?> <a href="http://www.wolfcms.org/" title="Wolf">Your name</a><br />\r\n  <a href="http://www.wolfcms.org/" title="Wolf CMS">Wolf CMS</a> Inside.\r\n  </p>\r\n  \r\n</div><!-- / #footer -->\r\n<!-- FOOTER / END -->\r\n\r\n</body>\r\n</html>	2018-08-03 07:44:34	2018-08-03 07:44:35	1	1	\N
3	Simple	text/html	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\r\n"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\r\n<html xmlns="http://www.w3.org/1999/xhtml">\r\n<head>\r\n  <title><?php echo $this->title(); ?></title>\r\n\r\n  <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8" />\r\n  <meta name="robots" content="index, follow" />\r\n  <meta name="description" content="<?php echo ($this->description() != '') ? $this->description() : 'Default description goes here'; ?>" />\r\n  <meta name="keywords" content="<?php echo ($this->keywords() != '') ? $this->keywords() : 'default, keywords, here'; ?>" />\r\n  <meta name="author" content="Author Name" />\r\n\r\n  <link rel="favourites icon" href="<?php echo THEMES_PATH; ?>wolf/images/favicon.ico" />\r\n    <link rel="stylesheet" href="<?php echo THEMES_PATH; ?>simple/screen.css" media="screen" type="text/css" />\r\n    <link rel="stylesheet" href="<?php echo THEMES_PATH; ?>simple/print.css" media="print" type="text/css" />\r\n    <link rel="alternate" type="application/rss+xml" title="Wolf Default RSS Feed" href="<?php echo URL_PUBLIC.((USE_MOD_REWRITE)?'':'/?'); ?>rss.xml" />\r\n\r\n</head>\r\n<body>\r\n<div id="page">\r\n<?php $this->includeSnippet('header'); ?>\r\n<div id="content">\r\n\r\n  <h2><?php echo $this->title(); ?></h2>\r\n  <?php echo $this->content(); ?> \r\n  <?php if ($this->hasContent('extended')) echo $this->content('extended'); ?> \r\n\r\n</div> <!-- end #content -->\r\n<div id="sidebar">\r\n\r\n  <?php echo $this->content('sidebar', true); ?> \r\n\r\n</div> <!-- end #sidebar -->\r\n<?php $this->includeSnippet('footer'); ?>\r\n</div> <!-- end #page -->\r\n</body>\r\n</html>	2018-08-03 07:44:36	2018-08-03 07:44:37	1	1	\N
4	RSS XML	application/rss+xml	<?php echo $this->content(); ?>	2018-08-03 07:44:38	2018-08-03 07:44:39	1	1	\N
\.


--
-- Data for Name: wolf_page; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_page (id, title, slug, breadcrumb, keywords, description, parent_id, layout_id, behavior_id, status_id, created_on, published_on, valid_until, updated_on, created_by_id, updated_by_id, "position", is_protected, needs_login) FROM stdin;
1	Home Page		Home Page	\N	\N	0	2		100	2018-08-03 07:44:40	2018-08-03 07:44:41	\N	2018-08-03 07:44:42	1	1	0	1	0
2	RSS Feed	rss.xml	RSS Feed	\N	\N	1	4		101	2018-08-03 07:44:43	2018-08-03 07:44:44	\N	2018-08-03 07:44:45	1	1	2	1	0
3	About us	about-us	About us	\N	\N	1	0		100	2018-08-03 07:44:46	2018-08-03 07:44:47	\N	2018-08-03 07:44:48	1	1	0	0	2
4	Articles	articles	Articles	\N	\N	1	0	archive	100	2018-08-03 07:44:49	2018-08-03 07:44:50	\N	2018-08-03 07:44:51	1	1	1	1	2
5	My first article	my-first-article	My first article	\N	\N	4	0		100	2018-08-03 07:44:52	2018-08-03 07:44:53	\N	2018-08-03 07:44:54	1	1	0	0	2
6	My second article	my-second-article	My second article	\N	\N	4	0		100	2018-08-03 07:44:55	2018-08-03 07:44:56	\N	2018-08-03 07:44:57	1	1	0	0	2
7	%B %Y archive	monthly-archive	%B %Y archive	\N	\N	4	0	archive_month_index	101	2018-08-03 07:44:58	2018-08-03 07:44:59	\N	2018-08-03 07:45:00	1	1	0	1	2
\.


--
-- Data for Name: wolf_page_part; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_page_part (id, name, filter_id, content, content_html, page_id) FROM stdin;
1	body		<?php \r\n\r\n$page_article = $this->find('/articles/');\r\n\r\nif ($page_article->childrenCount() > 0) {\r\n    $last_article = $page_article->children(array('limit'=>1, 'order'=>'page.created_on DESC'));\r\n    $last_articles = $page_article->children(array('limit'=>4, 'offset' => 1, 'order'=>'page.created_on DESC'));\r\n?>\r\n<div class="first entry">\r\n  <h3><?php echo $last_article->link(); ?></h3>\r\n  <?php echo $last_article->content(); ?>\r\n  <?php if ($last_article->hasContent('extended')) echo $last_article->link('Continue Reading&#8230;'); ?>\r\n  <p class="info">Posted by <?php echo $last_article->author(); ?> on <?php echo $last_article->date(); ?></p>\r\n</div>\r\n\r\n<?php foreach ($last_articles as $article): ?>\r\n<div class="entry">\r\n  <h3><?php echo $article->link(); ?></h3>\r\n  <?php echo $article->content(); ?>\r\n  <?php if ($article->hasContent('extended')) echo $article->link('Continue Reading&#8230;'); ?>\r\n  <p class="info">Posted by <?php echo $article->author(); ?> on <?php echo $article->date(); ?></p>\r\n</div>\r\n\r\n<?php\r\n    endforeach; \r\n}\r\n?>	<?php \r\n\r\n$page_article = $this->find('/articles/');\r\n\r\nif ($page_article->childrenCount() > 0) {\r\n    $last_article = $page_article->children(array('limit'=>1, 'order'=>'page.created_on DESC'));\r\n    $last_articles = $page_article->children(array('limit'=>4, 'offset' => 1, 'order'=>'page.created_on DESC'));\r\n?>\r\n<div class="first entry">\r\n  <h3><?php echo $last_article->link(); ?></h3>\r\n  <?php echo $last_article->content(); ?>\r\n  <?php if ($last_article->hasContent('extended')) echo $last_article->link('Continue Reading&#8230;'); ?>\r\n  <p class="info">Posted by <?php echo $last_article->author(); ?> on <?php echo $last_article->date(); ?></p>\r\n</div>\r\n\r\n<?php foreach ($last_articles as $article): ?>\r\n<div class="entry">\r\n  <h3><?php echo $article->link(); ?></h3>\r\n  <?php echo $article->content(); ?>\r\n  <?php if ($article->hasContent('extended')) echo $article->link('Continue Reading&#8230;'); ?>\r\n  <p class="info">Posted by <?php echo $article->author(); ?> on <?php echo $article->date(); ?></p>\r\n</div>\r\n\r\n<?php\r\n    endforeach; \r\n}\r\n?>	1
2	body		<?php echo '<?'; ?>xml version="1.0" encoding="UTF-8"<?php echo '?>'; ?> \r\n<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">\r\n<channel>\r\n\t<title>Wolf CMS</title>\r\n\t<link><?php echo BASE_URL ?></link>\r\n\t<atom:link href="<?php echo BASE_URL ?>rss.xml" rel="self" type="application/rss\\+xml" />\r\n\t<language>en-us</language>\r\n\t<copyright>Copyright <?php echo date('Y'); ?>, wolfcms.org</copyright>\r\n\t<pubDate><?php echo strftime('%a, %d %b %Y %H:%M:%S %z'); ?></pubDate>\r\n\t<lastBuildDate><?php echo strftime('%a, %d %b %Y %H:%M:%S %z'); ?></lastBuildDate>\r\n\t<category>any</category>\r\n\t<generator>Wolf CMS</generator>\r\n\t<description>The main news feed from Wolf CMS.</description>\r\n\t<docs>http://www.rssboard.org/rss-specification</docs>\r\n\t<?php $articles = $this->find('articles'); ?>\r\n\t<?php foreach ($articles->children(array('limit' => 10, 'order' => 'page.created_on DESC')) as $article): ?>\r\n\t<item>\r\n\t\t<title><?php echo $article->title(); ?></title>\r\n\t\t<description><?php if ($article->hasContent('summary')) { echo $article->content('summary'); } else { echo strip_tags($article->content()); } ?></description>\r\n\t\t<pubDate><?php echo $article->date('%a, %d %b %Y %H:%M:%S %z'); ?></pubDate>\r\n\t\t<link><?php echo $article->url(); ?></link>\r\n\t\t<guid><?php echo $article->url(); ?></guid>\r\n\t</item>\r\n\t<?php endforeach; ?>\r\n</channel>\r\n</rss>	<?php echo '<?'; ?>xml version="1.0" encoding="UTF-8"<?php echo '?>'; ?> \r\n<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">\r\n<channel>\r\n\t<title>Wolf CMS</title>\r\n\t<link><?php echo BASE_URL ?></link>\r\n\t<atom:link href="<?php echo BASE_URL ?>rss.xml" rel="self" type="application/rss\\+xml" />\r\n\t<language>en-us</language>\r\n\t<copyright>Copyright <?php echo date('Y'); ?>, wolfcms.org</copyright>\r\n\t<pubDate><?php echo strftime('%a, %d %b %Y %H:%M:%S %z'); ?></pubDate>\r\n\t<lastBuildDate><?php echo strftime('%a, %d %b %Y %H:%M:%S %z'); ?></lastBuildDate>\r\n\t<category>any</category>\r\n\t<generator>Wolf CMS</generator>\r\n\t<description>The main news feed from Wolf CMS.</description>\r\n\t<docs>http://www.rssboard.org/rss-specification</docs>\r\n\t<?php $articles = $this->find('articles'); ?>\r\n\t<?php foreach ($articles->children(array('limit' => 10, 'order' => 'page.created_on DESC')) as $article): ?>\r\n\t<item>\r\n\t\t<title><?php echo $article->title(); ?></title>\r\n\t\t<description><?php if ($article->hasContent('summary')) { echo $article->content('summary'); } else { echo strip_tags($article->content()); } ?></description>\r\n\t\t<pubDate><?php echo $article->date('%a, %d %b %Y %H:%M:%S %z'); ?></pubDate>\r\n\t\t<link><?php echo $article->url(); ?></link>\r\n\t\t<guid><?php echo $article->url(); ?></guid>\r\n\t</item>\r\n\t<?php endforeach; ?>\r\n</channel>\r\n</rss>	2
3	body	textile	This is my site. I live in this city ... I do some nice things, like this and that ...	<p>This is my site. I live in this city &#8230; I do some nice things, like this and that &#8230;</p>	3
4	body		<?php $last_articles = $this->children(array('limit'=>5, 'order'=>'page.created_on DESC')); ?>\r\n<?php foreach ($last_articles as $article): ?>\r\n<div class="entry">\r\n  <h3><?php echo $article->link($article->title); ?></h3>\r\n  <?php echo $article->content(); ?>\r\n  <p class="info">Posted by <?php echo $article->author(); ?> on <?php echo $article->date(); ?>  \r\n     <br />tags: <?php echo join(', ', $article->tags()); ?>\r\n  </p>\r\n</div>\r\n<?php endforeach; ?>\r\n\r\n	<?php $last_articles = $this->children(array('limit'=>5, 'order'=>'page.created_on DESC')); ?>\r\n<?php foreach ($last_articles as $article): ?>\r\n<div class="entry">\r\n  <h3><?php echo $article->link($article->title); ?></h3>\r\n  <?php echo $article->content(); ?>\r\n  <p class="info">Posted by <?php echo $article->author(); ?> on <?php echo $article->date(); ?>  \r\n     <br />tags: <?php echo join(', ', $article->tags()); ?>\r\n  </p>\r\n</div>\r\n<?php endforeach; ?>\r\n\r\n	4
5	body	markdown	My **first** test of my first article that uses *Markdown*.	<p>My <strong>first</strong> test of my first article that uses <em>Markdown</em>.</p>\n	5
7	body	markdown	This is my second article.	<p>This is my second article.</p>\n	6
8	body		<?php $archives = $this->archive->get(); ?>\r\n<?php foreach ($archives as $archive): ?>\r\n<div class="entry">\r\n  <h3><?php echo $archive->link(); ?></h3>\r\n  <p class="info">Posted by <?php echo $archive->author(); ?> on <?php echo $archive->date(); ?> \r\n  </p>\r\n</div>\r\n<?php endforeach; ?>	<?php $archives = $this->archive->get(); ?>\r\n<?php foreach ($archives as $archive): ?>\r\n<div class="entry">\r\n  <h3><?php echo $archive->link(); ?></h3>\r\n  <p class="info">Posted by <?php echo $archive->author(); ?> on <?php echo $archive->date(); ?> \r\n  </p>\r\n</div>\r\n<?php endforeach; ?>	7
9	sidebar		<h3>About Me</h3>\r\n\r\n<p>I'm just a demonstration of how easy it is to use Wolf CMS to power a blog. <a href="<?php echo BASE_URL; ?>about-us/">more ...</a></p>\r\n\r\n<h3>Favorite Sites</h3>\r\n<ul>\r\n  <li><a href="http://www.wolfcms.org">Wolf CMS</a></li>\r\n</ul>\r\n\r\n<?php if(url_match('/')): ?>\r\n<h3>Recent Entries</h3>\r\n<?php $page_article = $this->find('/articles/'); ?>\r\n<ul>\r\n<?php foreach ($page_article->children(array('limit' => 10, 'order' => 'page.created_on DESC')) as $article): ?>\r\n  <li><?php echo $article->link(); ?></li> \r\n<?php endforeach; ?>\r\n</ul>\r\n<?php endif; ?>\r\n\r\n<p><a href="<?php echo BASE_URL; ?>articles/">Archives</a></p>\r\n\r\n<h3>Syndicate</h3>\r\n\r\n<p><a href="<?php echo BASE_URL; ?>rss.xml">Articles RSS Feed</a></p>	<h3>About Me</h3>\r\n\r\n<p>I'm just a demonstration of how easy it is to use Wolf CMS to power a blog. <a href="<?php echo BASE_URL; ?>about-us/">more ...</a></p>\r\n\r\n<h3>Favorite Sites</h3>\r\n<ul>\r\n  <li><a href="http://www.wolfcms.org">Wolf CMS</a></li>\r\n</ul>\r\n\r\n<?php if(url_match('/')): ?>\r\n<h3>Recent Entries</h3>\r\n<?php $page_article = $this->find('/articles/'); ?>\r\n<ul>\r\n<?php foreach ($page_article->children(array('limit' => 10, 'order' => 'page.created_on DESC')) as $article): ?>\r\n  <li><?php echo $article->link(); ?></li> \r\n<?php endforeach; ?>\r\n</ul>\r\n<?php endif; ?>\r\n\r\n<p><a href="<?php echo BASE_URL; ?>articles/">Archives</a></p>\r\n\r\n<h3>Syndicate</h3>\r\n\r\n<p><a href="<?php echo BASE_URL; ?>rss.xml">Articles RSS Feed</a></p>	1
10	sidebar		<?php $article = $this->find('articles'); ?>\r\n<?php $archives = $article->archive->archivesByMonth(); ?>\r\n\r\n<h3>Archives By Month</h3>\r\n<ul>\r\n<?php foreach ($archives as $date): ?>\r\n  <li><a href="<?php echo $this->url(false) .'/'. $date . URL_SUFFIX; ?>"><?php echo strftime('%B %Y', strtotime(strtr($date, '/', '-'))); ?></a></li>\r\n<?php endforeach; ?>\r\n</ul>	<?php $article = $this->find('articles'); ?>\r\n<?php $archives = $article->archive->archivesByMonth(); ?>\r\n\r\n<h3>Archives By Month</h3>\r\n<ul>\r\n<?php foreach ($archives as $date): ?>\r\n  <li><a href="<?php echo $this->url(false) .'/'. $date . URL_SUFFIX; ?>"><?php echo strftime('%B %Y', strtotime(strtr($date, '/', '-'))); ?></a></li>\r\n<?php endforeach; ?>\r\n</ul>	4
\.


--
-- Data for Name: wolf_page_tag; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_page_tag (page_id, tag_id) FROM stdin;
\.


--
-- Data for Name: wolf_permission; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_permission (id, name) FROM stdin;
1	admin_view
2	admin_edit
3	user_view
4	user_add
5	user_edit
6	user_delete
7	layout_view
8	layout_add
9	layout_edit
10	layout_delete
11	snippet_view
12	snippet_add
13	snippet_edit
14	snippet_delete
15	page_view
16	page_add
17	page_edit
18	page_delete
19	file_manager_view
20	file_manager_upload
21	file_manager_mkdir
22	file_manager_mkfile
23	file_manager_rename
24	file_manager_chmod
25	file_manager_delete
26	backup_restore_view
\.


--
-- Data for Name: wolf_plugin_settings; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_plugin_settings (plugin_id, name, value) FROM stdin;
archive	use_dates	1
file_manager	umask	0022
file_manager	dirmode	0755
file_manager	filemode	0644
file_manager	show_hidden	0
file_manager	show_backups	1
\.


--
-- Data for Name: wolf_role; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_role (id, name) FROM stdin;
1	administrator
2	developer
3	editor
\.


--
-- Data for Name: wolf_role_permission; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_role_permission (role_id, permission_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
1	6
1	7
1	8
1	9
1	10
1	11
1	12
1	13
1	14
1	15
1	16
1	17
1	18
1	19
1	20
1	21
1	22
1	23
1	24
1	25
1	26
2	1
2	7
2	8
2	9
2	10
2	11
2	12
2	13
2	14
2	15
2	16
2	17
2	18
2	19
2	20
2	21
2	22
2	23
2	24
2	25
2	26
3	1
3	15
3	16
3	17
3	18
3	19
3	20
3	21
3	22
3	23
3	24
3	25
\.


--
-- Data for Name: wolf_secure_token; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_secure_token (id, username, url, "time") FROM stdin;
1	admin	e4ec68a078933b2868c16d145e3413b91e8bb79e61a5b1f4c51dbb8e7aed46d9	1533282327.0306
2	admin	4f0ea57074f160b29e3e42699cdcaefe75d218a8ee62df5c3c8055e2c316300e	1533282327.0556
3	admin	01d78375b155edc2d2dc45a4c80d3f730dd30a8c748dbf4d3f75fc43efcd184b	1533282327.0635
4	admin	793c857d7e625214853d1906ad75871c366696bbf4cd26e16be3b5b222f534fe	1533282327.0706
5	admin	068816621b05b161ec89adfeb46c4bf4c1521aa45bd9df9a939a3a183ea76650	1533283839.2901
6	admin	f0d9275f65621b85090d951524b9168b03bac2aca6e9a55102dd3019bd9db108	1533283839.3363
7	admin	b5fbfb804c10eec64db66c686bb8c9ffb72b88cabd86f5851d2622f6c80d7107	1533283839.3401
8	admin	6f3caba9644d13939b52d2c683f12238557e1cb4ee4be27762193a74ce685836	1533283839.3436
9	admin	891f0c41a08ab8177b95afe942dd60d33efed612858e9332810e8d5ab3ee5e88	1533285534.05
10	admin	f7d1ad5c50b051139c14f49fc9ab09d2f837eb13f91ce86fc75e3f2e020c3948	1533285534.0547
11	admin	451080b92d60deace78ebb2860d2f3979590a3912f9dcaff5e51f02e2e896772	1533285534.0582
12	admin	dbd6f42c8936c58bb156f4ab53adccf8291df675bce71add75d66d47359bcb73	1533285534.0614
13	admin	57540741f31c0274efd2607815d534859eca777467b7ff861a8fb5a876dae294	1533285858.1121
14	admin	9d970e192bd902581071b30b4f19b69a7b7e5ec01c231d3d9347c23b43b2ab46	1533285858.1163
15	admin	e4e5a5544d431770303d9348e812fd7e3d3db293c9dc9320e5ef2d4fb65ae1e3	1533285858.1195
16	admin	41e42941c85746079566148f531720fe57ecb211a9c9fac381c3b8a98d4db986	1533285858.1226
\.


--
-- Data for Name: wolf_setting; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_setting (name, value) FROM stdin;
admin_title	Wolf CMS
admin_email	do-not-reply@wolfcms.org
language	en
theme	brown_and_green
default_status_id	1
default_filter_id	
default_tab	
allow_html_title	off
plugins	a:5:{s:7:"textile";i:1;s:8:"markdown";i:1;s:7:"archive";i:1;s:14:"page_not_found";i:1;s:12:"file_manager";i:1;}
\.


--
-- Data for Name: wolf_snippet; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_snippet (id, name, filter_id, content, content_html, created_on, updated_on, created_by_id, updated_by_id, "position") FROM stdin;
1	header		<div id="header">\r\n  <h1><a href="<?php echo URL_PUBLIC; ?>">Wolf</a> <span>content management simplified</span></h1>\r\n  <div id="nav">\r\n    <ul>\r\n      <li><a<?php echo url_match('/') ? ' class="current"': ''; ?> href="<?php echo URL_PUBLIC; ?>">Home</a></li>\r\n<?php foreach($this->find('/')->children() as $menu): ?>\r\n      <li><?php echo $menu->link($menu->title, (in_array($menu->slug, explode('/', $this->path())) ? ' class="current"': null)); ?></li>\r\n<?php endforeach; ?> \r\n    </ul>\r\n  </div> <!-- end #navigation -->\r\n</div> <!-- end #header -->	<div id="header">\r\n  <h1><a href="<?php echo URL_PUBLIC; ?>">Wolf</a> <span>content management simplified</span></h1>\r\n  <div id="nav">\r\n    <ul>\r\n      <li><a<?php echo url_match('/') ? ' class="current"': ''; ?> href="<?php echo URL_PUBLIC; ?>">Home</a></li>\r\n<?php foreach($this->find('/')->children() as $menu): ?>\r\n      <li><?php echo $menu->link($menu->title, (in_array($menu->slug, explode('/', $this->path())) ? ' class="current"': null)); ?></li>\r\n<?php endforeach; ?> \r\n    </ul>\r\n  </div> <!-- end #navigation -->\r\n</div> <!-- end #header -->	2018-08-03 07:45:01	2018-08-03 07:45:02	1	1	\N
2	footer		<div id="footer"><div id="footer-inner">\r\n  <p>&copy; Copyright <?php echo date('Y'); ?> <a href="http://www.wolfcms.org/" title="Wolf">Your Name</a><br />\r\n  <a href="http://www.wolfcms.org/" title="Wolf CMS">Wolf CMS</a> Inside.\r\n  </p>\r\n</div></div><!-- end #footer -->	<div id="footer"><div id="footer-inner">\r\n  <p>&copy; Copyright <?php echo date('Y'); ?> <a href="http://www.wolfcms.org/" alt="Wolf">Your Name</a><br />\r\n  <a href="http://www.wolfcms.org/" alt="Wolf">Wolf CMS</a> Inside.\r\n  </p>\r\n</div></div><!-- end #footer -->	2018-08-03 07:45:03	2018-08-03 07:45:04	1	1	\N
\.


--
-- Data for Name: wolf_tag; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_tag (id, name, count) FROM stdin;
\.


--
-- Data for Name: wolf_user; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_user (id, name, email, username, password, salt, language, last_login, last_failure, failure_count, created_on, updated_on, created_by_id, updated_by_id) FROM stdin;
1	Administrator	admin@yoursite.com	admin	9b297e9727a97fe7f6b60d40ab2c966a2ab8e9a25674a372002f7f90554004066e08ebf7ca07d15f69a4e740a266ed008058ba285c71d9f21d14989a4a44c4c5	a810e9d4be45a413e002b8d209966c8466cf45d2c68ad6aa3d4e5f516de136d0	en	2018-08-03 08:44:17	\N	0	2018-08-03 07:45:05	2018-08-03 08:44:17	1	\N
\.


--
-- Data for Name: wolf_user_role; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.wolf_user_role (user_id, role_id) FROM stdin;
1	1
\.


--
-- Name: wolf_cron_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_cron_id_seq', 2, false);


--
-- Name: wolf_layout_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_layout_id_seq', 5, false);


--
-- Name: wolf_page_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_page_id_seq', 8, false);


--
-- Name: wolf_page_part_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_page_part_id_seq', 11, false);


--
-- Name: wolf_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_permission_id_seq', 27, false);


--
-- Name: wolf_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_role_id_seq', 4, false);


--
-- Name: wolf_secure_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_secure_token_id_seq', 16, true);


--
-- Name: wolf_snippet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_snippet_id_seq', 3, false);


--
-- Name: wolf_tag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_tag_id_seq', 1, false);


--
-- Name: wolf_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.wolf_user_id_seq', 2, false);


--
-- Name: wolf_setting id; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_setting
    ADD CONSTRAINT id UNIQUE (name);


--
-- Name: wolf_layout layoutname; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_layout
    ADD CONSTRAINT layoutname UNIQUE (name);


--
-- Name: wolf_page_tag page_id; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_page_tag
    ADD CONSTRAINT page_id UNIQUE (page_id, tag_id);


--
-- Name: wolf_permission permissionname; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_permission
    ADD CONSTRAINT permissionname UNIQUE (name);


--
-- Name: wolf_plugin_settings plugin_setting_id; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_plugin_settings
    ADD CONSTRAINT plugin_setting_id UNIQUE (plugin_id, name);


--
-- Name: wolf_role_permission role_id; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_role_permission
    ADD CONSTRAINT role_id UNIQUE (role_id, permission_id);


--
-- Name: wolf_role rolename; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_role
    ADD CONSTRAINT rolename UNIQUE (name);


--
-- Name: wolf_snippet snippetname; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_snippet
    ADD CONSTRAINT snippetname UNIQUE (name);


--
-- Name: wolf_tag tagname; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_tag
    ADD CONSTRAINT tagname UNIQUE (name);


--
-- Name: wolf_user uc_email; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_user
    ADD CONSTRAINT uc_email UNIQUE (email);


--
-- Name: wolf_user_role user_id; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_user_role
    ADD CONSTRAINT user_id UNIQUE (user_id, role_id);


--
-- Name: wolf_user username; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_user
    ADD CONSTRAINT username UNIQUE (username);


--
-- Name: wolf_secure_token username_url; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_secure_token
    ADD CONSTRAINT username_url UNIQUE (username, url);


--
-- Name: wolf_cron wolf_cron_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_cron
    ADD CONSTRAINT wolf_cron_pkey PRIMARY KEY (id);


--
-- Name: wolf_layout wolf_layout_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_layout
    ADD CONSTRAINT wolf_layout_pkey PRIMARY KEY (id);


--
-- Name: wolf_page_part wolf_page_part_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_page_part
    ADD CONSTRAINT wolf_page_part_pkey PRIMARY KEY (id);


--
-- Name: wolf_page wolf_page_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_page
    ADD CONSTRAINT wolf_page_pkey PRIMARY KEY (id);


--
-- Name: wolf_permission wolf_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_permission
    ADD CONSTRAINT wolf_permission_pkey PRIMARY KEY (id);


--
-- Name: wolf_role wolf_role_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_role
    ADD CONSTRAINT wolf_role_pkey PRIMARY KEY (id);


--
-- Name: wolf_secure_token wolf_secure_token_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_secure_token
    ADD CONSTRAINT wolf_secure_token_pkey PRIMARY KEY (id);


--
-- Name: wolf_snippet wolf_snippet_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_snippet
    ADD CONSTRAINT wolf_snippet_pkey PRIMARY KEY (id);


--
-- Name: wolf_tag wolf_tag_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_tag
    ADD CONSTRAINT wolf_tag_pkey PRIMARY KEY (id);


--
-- Name: wolf_user wolf_user_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.wolf_user
    ADD CONSTRAINT wolf_user_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

