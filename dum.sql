--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE active_admin_comments (
    id integer NOT NULL,
    namespace character varying(255),
    body text,
    resource_id character varying(255) NOT NULL,
    resource_type character varying(255) NOT NULL,
    author_id integer,
    author_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE active_admin_comments OWNER TO mxing_v2;

--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE active_admin_comments_id_seq OWNER TO mxing_v2;

--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE active_admin_comments_id_seq OWNED BY active_admin_comments.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE activities (
    id integer NOT NULL,
    title character varying,
    cover character varying,
    address character varying,
    group_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    content text,
    start_date date,
    end_date date,
    activity_type integer,
    theme integer,
    pos integer DEFAULT 0
);


ALTER TABLE activities OWNER TO mxing_v2;

--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activities_id_seq OWNER TO mxing_v2;

--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE activities_id_seq OWNED BY activities.id;


--
-- Name: address_coordinates; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE address_coordinates (
    id integer NOT NULL,
    address_id integer,
    lonlat geography(Point,4326)
);


ALTER TABLE address_coordinates OWNER TO mxing_v2;

--
-- Name: address_coordinates_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE address_coordinates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE address_coordinates_id_seq OWNER TO mxing_v2;

--
-- Name: address_coordinates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE address_coordinates_id_seq OWNED BY address_coordinates.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    coach_id integer,
    venues character varying,
    city character varying,
    address character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE addresses OWNER TO mxing_v2;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE addresses_id_seq OWNER TO mxing_v2;

--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE admin_users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    role integer,
    service_id integer
);


ALTER TABLE admin_users OWNER TO mxing_v2;

--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE admin_users_id_seq OWNER TO mxing_v2;

--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE admin_users_id_seq OWNED BY admin_users.id;


--
-- Name: ads; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE ads (
    id integer NOT NULL,
    image character varying(255),
    url character varying(255),
    from_date date,
    end_date date
);


ALTER TABLE ads OWNER TO mxing_v2;

--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ads_id_seq OWNER TO mxing_v2;

--
-- Name: ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE ads_id_seq OWNED BY ads.id;


--
-- Name: applies; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE applies (
    id integer NOT NULL,
    activity_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE applies OWNER TO mxing_v2;

--
-- Name: applies_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE applies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE applies_id_seq OWNER TO mxing_v2;

--
-- Name: applies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE applies_id_seq OWNED BY applies.id;


--
-- Name: appointment_settings; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE appointment_settings (
    id integer NOT NULL,
    coach_id integer,
    start_date date,
    "time" character varying,
    address_id integer,
    repeat boolean,
    course_name character varying,
    course_type character varying,
    place integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE appointment_settings OWNER TO mxing_v2;

--
-- Name: appointment_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE appointment_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE appointment_settings_id_seq OWNER TO mxing_v2;

--
-- Name: appointment_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE appointment_settings_id_seq OWNED BY appointment_settings.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE appointments (
    id integer NOT NULL,
    coach_id integer,
    user_id integer,
    course_id integer,
    amount integer,
    status integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    sku character varying,
    code character varying
);


ALTER TABLE appointments OWNER TO mxing_v2;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE appointments_id_seq OWNER TO mxing_v2;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE appointments_id_seq OWNED BY appointments.id;


--
-- Name: auto_logins; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE auto_logins (
    id integer NOT NULL,
    user_id integer,
    device character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE auto_logins OWNER TO mxing_v2;

--
-- Name: auto_logins_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE auto_logins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_logins_id_seq OWNER TO mxing_v2;

--
-- Name: auto_logins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE auto_logins_id_seq OWNED BY auto_logins.id;


--
-- Name: banners; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE banners (
    id integer NOT NULL,
    image character varying,
    url character varying,
    start_date date,
    end_date date,
    type integer,
    link_id integer
);


ALTER TABLE banners OWNER TO mxing_v2;

--
-- Name: banners_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE banners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE banners_id_seq OWNER TO mxing_v2;

--
-- Name: banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE banners_id_seq OWNED BY banners.id;


--
-- Name: black_lists; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE black_lists (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE black_lists OWNER TO mxing_v2;

--
-- Name: black_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE black_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE black_lists_id_seq OWNER TO mxing_v2;

--
-- Name: black_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE black_lists_id_seq OWNED BY black_lists.id;


--
-- Name: blacklists; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE blacklists (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE blacklists OWNER TO mxing_v2;

--
-- Name: blacklists_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE blacklists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE blacklists_id_seq OWNER TO mxing_v2;

--
-- Name: blacklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE blacklists_id_seq OWNED BY blacklists.id;


--
-- Name: captchas; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE captchas (
    id integer NOT NULL,
    mobile character varying,
    captcha character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE captchas OWNER TO mxing_v2;

--
-- Name: captchas_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE captchas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE captchas_id_seq OWNER TO mxing_v2;

--
-- Name: captchas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE captchas_id_seq OWNED BY captchas.id;


--
-- Name: checks; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE checks (
    id integer NOT NULL,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE checks OWNER TO mxing_v2;

--
-- Name: checks_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE checks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE checks_id_seq OWNER TO mxing_v2;

--
-- Name: checks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE checks_id_seq OWNED BY checks.id;


--
-- Name: ckeditor_assets; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE ckeditor_assets (
    id integer NOT NULL,
    data_file_name character varying NOT NULL,
    data_content_type character varying,
    data_file_size integer,
    assetable_id integer,
    assetable_type character varying(30),
    type character varying(30),
    width integer,
    height integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE ckeditor_assets OWNER TO mxing_v2;

--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE ckeditor_assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ckeditor_assets_id_seq OWNER TO mxing_v2;

--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE ckeditor_assets_id_seq OWNED BY ckeditor_assets.id;


--
-- Name: coach_docs; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE coach_docs (
    id integer NOT NULL,
    coach_id integer,
    image character varying
);


ALTER TABLE coach_docs OWNER TO mxing_v2;

--
-- Name: coach_docs_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE coach_docs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE coach_docs_id_seq OWNER TO mxing_v2;

--
-- Name: coach_docs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE coach_docs_id_seq OWNED BY coach_docs.id;


--
-- Name: comment_images; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE comment_images (
    id integer NOT NULL,
    comment_id integer,
    image character varying
);


ALTER TABLE comment_images OWNER TO mxing_v2;

--
-- Name: comment_images_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE comment_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comment_images_id_seq OWNER TO mxing_v2;

--
-- Name: comment_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE comment_images_id_seq OWNED BY comment_images.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE comments (
    id integer NOT NULL,
    user_id integer,
    content character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    score integer,
    sku character varying,
    image character varying[] DEFAULT '{}'::character varying[]
);


ALTER TABLE comments OWNER TO mxing_v2;

--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comments_id_seq OWNER TO mxing_v2;

--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE companies (
    id integer NOT NULL,
    name character varying,
    avatar character varying,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE companies OWNER TO mxing_v2;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE companies_id_seq OWNER TO mxing_v2;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: company_coaches; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE company_coaches (
    id integer NOT NULL,
    company_id integer,
    coach_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE company_coaches OWNER TO mxing_v2;

--
-- Name: company_coaches_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE company_coaches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE company_coaches_id_seq OWNER TO mxing_v2;

--
-- Name: company_coaches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE company_coaches_id_seq OWNED BY company_coaches.id;


--
-- Name: company_shops; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE company_shops (
    id integer NOT NULL,
    company_id integer,
    shop_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE company_shops OWNER TO mxing_v2;

--
-- Name: company_shops_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE company_shops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE company_shops_id_seq OWNER TO mxing_v2;

--
-- Name: company_shops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE company_shops_id_seq OWNED BY company_shops.id;


--
-- Name: concerneds; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE concerneds (
    id integer NOT NULL,
    course_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE concerneds OWNER TO mxing_v2;

--
-- Name: concerneds_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE concerneds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE concerneds_id_seq OWNER TO mxing_v2;

--
-- Name: concerneds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE concerneds_id_seq OWNED BY concerneds.id;


--
-- Name: coupons; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE coupons (
    id integer NOT NULL,
    no character varying,
    name character varying,
    discount numeric,
    info text,
    start_date date,
    end_date date,
    limit_category character varying,
    limit_ext character varying,
    min character varying,
    active boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    code character varying[] DEFAULT '{}'::character varying[],
    amount integer DEFAULT 0,
    lock_version integer DEFAULT 0,
    used integer DEFAULT 0
);


ALTER TABLE coupons OWNER TO mxing_v2;

--
-- Name: coupons_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE coupons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE coupons_id_seq OWNER TO mxing_v2;

--
-- Name: coupons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE coupons_id_seq OWNED BY coupons.id;


--
-- Name: course_abstracts; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE course_abstracts (
    id integer NOT NULL,
    course_id integer,
    address_id integer,
    coach_id integer,
    coach_gender integer,
    course_price integer,
    course_type integer,
    coordinate geography(Point,4326)
);


ALTER TABLE course_abstracts OWNER TO mxing_v2;

--
-- Name: course_abstracts_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE course_abstracts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE course_abstracts_id_seq OWNER TO mxing_v2;

--
-- Name: course_abstracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE course_abstracts_id_seq OWNED BY course_abstracts.id;


--
-- Name: course_addresses; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE course_addresses (
    id integer NOT NULL,
    course_id integer,
    address_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE course_addresses OWNER TO mxing_v2;

--
-- Name: course_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE course_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE course_addresses_id_seq OWNER TO mxing_v2;

--
-- Name: course_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE course_addresses_id_seq OWNED BY course_addresses.id;


--
-- Name: course_photos; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE course_photos (
    id integer NOT NULL,
    course_id integer,
    photo character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE course_photos OWNER TO mxing_v2;

--
-- Name: course_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE course_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE course_photos_id_seq OWNER TO mxing_v2;

--
-- Name: course_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE course_photos_id_seq OWNED BY course_photos.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE courses (
    id integer NOT NULL,
    coach_id integer,
    name character varying,
    type integer,
    style character varying,
    during integer,
    price integer,
    exp character varying,
    proposal integer,
    intro text,
    customized boolean,
    custom_mxid character varying,
    custom_mobile character varying,
    top integer,
    status integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    address integer[] DEFAULT '{}'::integer[],
    guarantee integer DEFAULT 0,
    comments_count integer DEFAULT 0,
    concerns_count integer DEFAULT 0,
    order_items_count integer DEFAULT 0,
    special text DEFAULT ''::text,
    image character varying[] DEFAULT '{}'::character varying[]
);


ALTER TABLE courses OWNER TO mxing_v2;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE courses_id_seq OWNER TO mxing_v2;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE courses_id_seq OWNED BY courses.id;


--
-- Name: crawl_data; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE crawl_data (
    id integer NOT NULL,
    name character varying,
    avatar character varying,
    address character varying,
    tel character varying,
    business character varying,
    service character varying[],
    photo character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE crawl_data OWNER TO mxing_v2;

--
-- Name: crawl_data_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE crawl_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE crawl_data_id_seq OWNER TO mxing_v2;

--
-- Name: crawl_data_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE crawl_data_id_seq OWNED BY crawl_data.id;


--
-- Name: devices; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE devices (
    id integer NOT NULL,
    name character varying,
    system character varying,
    device character varying,
    channel character varying,
    version character varying,
    ip character varying,
    token character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE devices OWNER TO mxing_v2;

--
-- Name: devices_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE devices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE devices_id_seq OWNER TO mxing_v2;

--
-- Name: devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE devices_id_seq OWNED BY devices.id;


--
-- Name: dynamic_comments; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE dynamic_comments (
    id integer NOT NULL,
    dynamic_id integer,
    user_id integer,
    content character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE dynamic_comments OWNER TO mxing_v2;

--
-- Name: dynamic_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE dynamic_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dynamic_comments_id_seq OWNER TO mxing_v2;

--
-- Name: dynamic_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE dynamic_comments_id_seq OWNED BY dynamic_comments.id;


--
-- Name: dynamic_films; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE dynamic_films (
    id integer NOT NULL,
    dynamic_id integer,
    cover character varying(255),
    film character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    title character varying
);


ALTER TABLE dynamic_films OWNER TO mxing_v2;

--
-- Name: dynamic_films_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE dynamic_films_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dynamic_films_id_seq OWNER TO mxing_v2;

--
-- Name: dynamic_films_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE dynamic_films_id_seq OWNED BY dynamic_films.id;


--
-- Name: dynamic_images; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE dynamic_images (
    id integer NOT NULL,
    dynamic_id integer,
    image character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    width integer,
    height integer,
    tag character varying[] DEFAULT '{}'::character varying[]
);


ALTER TABLE dynamic_images OWNER TO mxing_v2;

--
-- Name: dynamic_images_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE dynamic_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dynamic_images_id_seq OWNER TO mxing_v2;

--
-- Name: dynamic_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE dynamic_images_id_seq OWNED BY dynamic_images.id;


--
-- Name: dynamics; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE dynamics (
    id integer NOT NULL,
    user_id integer,
    content text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    top integer DEFAULT 0
);


ALTER TABLE dynamics OWNER TO mxing_v2;

--
-- Name: dynamics_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE dynamics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dynamics_id_seq OWNER TO mxing_v2;

--
-- Name: dynamics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE dynamics_id_seq OWNED BY dynamics.id;


--
-- Name: expiries; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE expiries (
    id integer NOT NULL,
    coach_id integer,
    date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE expiries OWNER TO mxing_v2;

--
-- Name: expiries_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE expiries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE expiries_id_seq OWNER TO mxing_v2;

--
-- Name: expiries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE expiries_id_seq OWNED BY expiries.id;


--
-- Name: feedbacks; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE feedbacks (
    id integer NOT NULL,
    user_id integer,
    content text,
    contact character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE feedbacks OWNER TO mxing_v2;

--
-- Name: feedbacks_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE feedbacks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE feedbacks_id_seq OWNER TO mxing_v2;

--
-- Name: feedbacks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE feedbacks_id_seq OWNED BY feedbacks.id;


--
-- Name: follows; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE follows (
    id integer NOT NULL,
    service_id integer,
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE follows OWNER TO mxing_v2;

--
-- Name: follows_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE follows_id_seq OWNER TO mxing_v2;

--
-- Name: follows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE follows_id_seq OWNED BY follows.id;


--
-- Name: galleries; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE galleries (
    id integer NOT NULL,
    user_id integer,
    tag character varying
);


ALTER TABLE galleries OWNER TO mxing_v2;

--
-- Name: galleries_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE galleries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE galleries_id_seq OWNER TO mxing_v2;

--
-- Name: galleries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE galleries_id_seq OWNED BY galleries.id;


--
-- Name: gallery_images; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE gallery_images (
    id integer NOT NULL,
    gallery_id integer,
    image character varying,
    caption text
);


ALTER TABLE gallery_images OWNER TO mxing_v2;

--
-- Name: gallery_images_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE gallery_images_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gallery_images_id_seq OWNER TO mxing_v2;

--
-- Name: gallery_images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE gallery_images_id_seq OWNED BY gallery_images.id;


--
-- Name: group_members; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE group_members (
    id integer NOT NULL,
    group_id integer,
    user_id integer,
    tag integer,
    tag_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE group_members OWNER TO mxing_v2;

--
-- Name: group_members_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE group_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE group_members_id_seq OWNER TO mxing_v2;

--
-- Name: group_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE group_members_id_seq OWNED BY group_members.id;


--
-- Name: group_photos; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE group_photos (
    id integer NOT NULL,
    group_id integer,
    photo character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE group_photos OWNER TO mxing_v2;

--
-- Name: group_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE group_photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE group_photos_id_seq OWNER TO mxing_v2;

--
-- Name: group_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE group_photos_id_seq OWNED BY group_photos.id;


--
-- Name: group_places; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE group_places (
    id integer NOT NULL,
    group_id integer,
    lonlat geography(Point,4326),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE group_places OWNER TO mxing_v2;

--
-- Name: group_places_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE group_places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE group_places_id_seq OWNER TO mxing_v2;

--
-- Name: group_places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE group_places_id_seq OWNED BY group_places.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE groups (
    id integer NOT NULL,
    name character varying,
    interests character varying,
    intro text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    easemob_id character varying,
    owner integer
);


ALTER TABLE groups OWNER TO mxing_v2;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE groups_id_seq OWNER TO mxing_v2;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE groups_id_seq OWNED BY groups.id;


--
-- Name: hit_reports; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE hit_reports (
    id integer NOT NULL,
    report_date date,
    point integer,
    number integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE hit_reports OWNER TO mxing_v2;

--
-- Name: hit_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE hit_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hit_reports_id_seq OWNER TO mxing_v2;

--
-- Name: hit_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE hit_reports_id_seq OWNED BY hit_reports.id;


--
-- Name: hits; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE hits (
    id integer NOT NULL,
    date date,
    device character varying,
    point integer,
    number integer
);


ALTER TABLE hits OWNER TO mxing_v2;

--
-- Name: hits_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE hits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE hits_id_seq OWNER TO mxing_v2;

--
-- Name: hits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE hits_id_seq OWNED BY hits.id;


--
-- Name: lessons; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE lessons (
    id integer NOT NULL,
    order_id integer,
    coach_id integer,
    user_id integer,
    course_id integer,
    available integer,
    used integer,
    exp date,
    order_no character varying,
    contact_name character varying,
    contact_phone character varying,
    sku character varying
);


ALTER TABLE lessons OWNER TO mxing_v2;

--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE lessons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE lessons_id_seq OWNER TO mxing_v2;

--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE lessons_id_seq OWNED BY lessons.id;


--
-- Name: likes; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE likes (
    id integer NOT NULL,
    like_type integer,
    user_id integer,
    liked_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE likes OWNER TO mxing_v2;

--
-- Name: likes_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE likes_id_seq OWNER TO mxing_v2;

--
-- Name: likes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE likes_id_seq OWNED BY likes.id;


--
-- Name: mass_message_groups; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE mass_message_groups (
    id integer NOT NULL,
    service_id integer,
    name character varying,
    user_id integer[] DEFAULT '{}'::integer[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE mass_message_groups OWNER TO mxing_v2;

--
-- Name: mass_message_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE mass_message_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mass_message_groups_id_seq OWNER TO mxing_v2;

--
-- Name: mass_message_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE mass_message_groups_id_seq OWNED BY mass_message_groups.id;


--
-- Name: mass_messages; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE mass_messages (
    id integer NOT NULL,
    service_id integer,
    user_id integer[] DEFAULT '{}'::integer[],
    content character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE mass_messages OWNER TO mxing_v2;

--
-- Name: mass_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE mass_messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE mass_messages_id_seq OWNER TO mxing_v2;

--
-- Name: mass_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE mass_messages_id_seq OWNED BY mass_messages.id;


--
-- Name: news; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE news (
    id integer NOT NULL,
    title character varying,
    cover character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    content text,
    cover_width integer,
    cover_height integer,
    tag character varying DEFAULT ''::character varying
);


ALTER TABLE news OWNER TO mxing_v2;

--
-- Name: news_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE news_id_seq OWNER TO mxing_v2;

--
-- Name: news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE news_id_seq OWNED BY news.id;


--
-- Name: online_reports; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE online_reports (
    id integer NOT NULL,
    report_date date,
    avg integer,
    period integer,
    number integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE online_reports OWNER TO mxing_v2;

--
-- Name: online_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE online_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE online_reports_id_seq OWNER TO mxing_v2;

--
-- Name: online_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE online_reports_id_seq OWNED BY online_reports.id;


--
-- Name: onlines; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE onlines (
    id integer NOT NULL,
    date date,
    device character varying,
    open timestamp without time zone,
    close timestamp without time zone
);


ALTER TABLE onlines OWNER TO mxing_v2;

--
-- Name: onlines_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE onlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE onlines_id_seq OWNER TO mxing_v2;

--
-- Name: onlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE onlines_id_seq OWNED BY onlines.id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE order_items (
    id integer NOT NULL,
    order_id integer,
    course_id integer,
    name character varying,
    type integer,
    cover character varying,
    price character varying,
    amount integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    during integer,
    sku character varying
);


ALTER TABLE order_items OWNER TO mxing_v2;

--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE order_items_id_seq OWNER TO mxing_v2;

--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE order_items_id_seq OWNED BY order_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE orders (
    id integer NOT NULL,
    user_id integer,
    coach_id integer,
    no character varying,
    coupons character varying,
    bean integer,
    contact_name character varying,
    contact_phone character varying,
    pay_type character varying,
    total numeric,
    pay_amount numeric DEFAULT 0,
    status character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    service_id integer
);


ALTER TABLE orders OWNER TO mxing_v2;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE orders_id_seq OWNER TO mxing_v2;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: overviews; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE overviews (
    id integer NOT NULL,
    report_date date,
    activation integer,
    register integer,
    activity integer
);


ALTER TABLE overviews OWNER TO mxing_v2;

--
-- Name: overviews_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE overviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE overviews_id_seq OWNER TO mxing_v2;

--
-- Name: overviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE overviews_id_seq OWNED BY overviews.id;


--
-- Name: photos; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE photos (
    id integer NOT NULL,
    user_id integer,
    photo character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    loc integer
);


ALTER TABLE photos OWNER TO mxing_v2;

--
-- Name: photos_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE photos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE photos_id_seq OWNER TO mxing_v2;

--
-- Name: photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE photos_id_seq OWNED BY photos.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE places (
    id integer NOT NULL,
    user_id integer,
    lonlat geography(Point,4326),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE places OWNER TO mxing_v2;

--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE places_id_seq OWNER TO mxing_v2;

--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE places_id_seq OWNED BY places.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE profiles (
    id integer NOT NULL,
    user_id integer,
    signature character varying(255) DEFAULT ''::character varying,
    name character varying(255) DEFAULT ''::character varying,
    avatar character varying(255) DEFAULT ''::character varying,
    gender integer DEFAULT 0,
    identity integer DEFAULT 0,
    birthday date DEFAULT '1999-03-20'::date,
    address character varying(255) DEFAULT ''::character varying,
    target character varying(255) DEFAULT ''::character varying,
    skill character varying(255) DEFAULT ''::character varying,
    often_stadium character varying(255) DEFAULT ''::character varying,
    interests character varying(255) DEFAULT ''::character varying,
    mobile character varying(255) DEFAULT ''::character varying,
    service integer[] DEFAULT '{}'::integer[],
    hobby integer[] DEFAULT '{}'::integer[],
    province character varying,
    city character varying
);


ALTER TABLE profiles OWNER TO mxing_v2;

--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE profiles_id_seq OWNER TO mxing_v2;

--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: recommends; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE recommends (
    id integer NOT NULL,
    type integer,
    recommended_id integer,
    recommended_tip text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE recommends OWNER TO mxing_v2;

--
-- Name: recommends_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE recommends_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE recommends_id_seq OWNER TO mxing_v2;

--
-- Name: recommends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE recommends_id_seq OWNED BY recommends.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE reports (
    id integer NOT NULL,
    report_type integer,
    content text,
    user_id integer,
    report_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE reports OWNER TO mxing_v2;

--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE reports_id_seq OWNER TO mxing_v2;

--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE reports_id_seq OWNED BY reports.id;


--
-- Name: retentions; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE retentions (
    id integer NOT NULL,
    report_date date,
    register integer,
    day_one numeric,
    day_three numeric,
    day_seven numeric
);


ALTER TABLE retentions OWNER TO mxing_v2;

--
-- Name: retentions_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE retentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE retentions_id_seq OWNER TO mxing_v2;

--
-- Name: retentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE retentions_id_seq OWNED BY retentions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE schema_migrations OWNER TO mxing_v2;

--
-- Name: service_courses; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE service_courses (
    id integer NOT NULL,
    name character varying DEFAULT ''::character varying,
    type integer DEFAULT 0,
    style character varying DEFAULT ''::character varying,
    during integer,
    proposal integer,
    exp integer,
    intro text DEFAULT ''::text,
    special text DEFAULT ''::text,
    service integer[] DEFAULT '{}'::integer[],
    limit_start timestamp without time zone,
    limit_end timestamp without time zone,
    status integer DEFAULT 0,
    image character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE service_courses OWNER TO mxing_v2;

--
-- Name: service_courses_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE service_courses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE service_courses_id_seq OWNER TO mxing_v2;

--
-- Name: service_courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE service_courses_id_seq OWNED BY service_courses.id;


--
-- Name: service_members; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE service_members (
    id integer NOT NULL,
    service_id integer,
    coach_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE service_members OWNER TO mxing_v2;

--
-- Name: service_members_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE service_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE service_members_id_seq OWNER TO mxing_v2;

--
-- Name: service_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE service_members_id_seq OWNED BY service_members.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE settings (
    id integer NOT NULL,
    user_id integer,
    stealth integer
);


ALTER TABLE settings OWNER TO mxing_v2;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE settings_id_seq OWNER TO mxing_v2;

--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE settings_id_seq OWNED BY settings.id;


--
-- Name: showtimes; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE showtimes (
    id integer NOT NULL,
    user_id integer,
    title character varying(255),
    cover character varying(255),
    film character varying(255),
    intro character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE showtimes OWNER TO mxing_v2;

--
-- Name: showtimes_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE showtimes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE showtimes_id_seq OWNER TO mxing_v2;

--
-- Name: showtimes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE showtimes_id_seq OWNED BY showtimes.id;


--
-- Name: skus; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE skus (
    id integer NOT NULL,
    sku character varying,
    course_id integer,
    course_type integer,
    course_name character varying,
    course_cover character varying,
    course_guarantee integer,
    seller character varying,
    seller_id integer,
    market_price numeric,
    selling_price numeric,
    store integer,
    "limit" integer,
    address character varying,
    coordinate geography(Point,4326),
    comments_count integer DEFAULT 0,
    orders_count integer DEFAULT 0,
    concerns_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status integer DEFAULT 0,
    service_id integer
);


ALTER TABLE skus OWNER TO mxing_v2;

--
-- Name: skus_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE skus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE skus_id_seq OWNER TO mxing_v2;

--
-- Name: skus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE skus_id_seq OWNED BY skus.id;


--
-- Name: tracks; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE tracks (
    id integer NOT NULL,
    user_id integer,
    track_type integer,
    start timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    name character varying,
    intro text,
    address character varying,
    places integer,
    free_places integer DEFAULT 0,
    coach_id integer,
    during integer DEFAULT 60
);


ALTER TABLE tracks OWNER TO mxing_v2;

--
-- Name: tracks_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE tracks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE tracks_id_seq OWNER TO mxing_v2;

--
-- Name: tracks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE tracks_id_seq OWNED BY tracks.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE transactions (
    id integer NOT NULL,
    no character varying,
    order_no character varying,
    source character varying,
    buyer character varying,
    price numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE transactions OWNER TO mxing_v2;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE transactions_id_seq OWNER TO mxing_v2;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE transactions_id_seq OWNED BY transactions.id;


--
-- Name: type_shows; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE type_shows (
    id integer NOT NULL,
    title character varying,
    cover character varying,
    url character varying,
    content text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE type_shows OWNER TO mxing_v2;

--
-- Name: type_shows_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE type_shows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE type_shows_id_seq OWNER TO mxing_v2;

--
-- Name: type_shows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE type_shows_id_seq OWNED BY type_shows.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    mobile character varying(255) DEFAULT ''::character varying,
    password character varying(255),
    salt character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    sns character varying DEFAULT ''::character varying,
    device character varying DEFAULT ''::character varying,
    views integer DEFAULT 14000,
    status integer DEFAULT 1
);


ALTER TABLE users OWNER TO mxing_v2;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO mxing_v2;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: wallet_logs; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE wallet_logs (
    id integer NOT NULL,
    wallet_id integer,
    action integer,
    balance integer,
    coupons character varying,
    bean integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE wallet_logs OWNER TO mxing_v2;

--
-- Name: wallet_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE wallet_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wallet_logs_id_seq OWNER TO mxing_v2;

--
-- Name: wallet_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE wallet_logs_id_seq OWNED BY wallet_logs.id;


--
-- Name: wallets; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE wallets (
    id integer NOT NULL,
    user_id integer,
    balance numeric DEFAULT 0,
    bean integer DEFAULT 0,
    coupons integer[] DEFAULT '{}'::integer[],
    lock_version integer
);


ALTER TABLE wallets OWNER TO mxing_v2;

--
-- Name: wallets_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE wallets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE wallets_id_seq OWNER TO mxing_v2;

--
-- Name: wallets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE wallets_id_seq OWNED BY wallets.id;


--
-- Name: withdraws; Type: TABLE; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE TABLE withdraws (
    id integer NOT NULL,
    coach_id integer,
    account character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying DEFAULT ''::character varying,
    amount numeric DEFAULT 0,
    status integer DEFAULT 0
);


ALTER TABLE withdraws OWNER TO mxing_v2;

--
-- Name: withdraws_id_seq; Type: SEQUENCE; Schema: public; Owner: mxing_v2
--

CREATE SEQUENCE withdraws_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE withdraws_id_seq OWNER TO mxing_v2;

--
-- Name: withdraws_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mxing_v2
--

ALTER SEQUENCE withdraws_id_seq OWNED BY withdraws.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY active_admin_comments ALTER COLUMN id SET DEFAULT nextval('active_admin_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY activities ALTER COLUMN id SET DEFAULT nextval('activities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY address_coordinates ALTER COLUMN id SET DEFAULT nextval('address_coordinates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY admin_users ALTER COLUMN id SET DEFAULT nextval('admin_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY ads ALTER COLUMN id SET DEFAULT nextval('ads_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY applies ALTER COLUMN id SET DEFAULT nextval('applies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY appointment_settings ALTER COLUMN id SET DEFAULT nextval('appointment_settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY appointments ALTER COLUMN id SET DEFAULT nextval('appointments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY auto_logins ALTER COLUMN id SET DEFAULT nextval('auto_logins_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY banners ALTER COLUMN id SET DEFAULT nextval('banners_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY black_lists ALTER COLUMN id SET DEFAULT nextval('black_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY blacklists ALTER COLUMN id SET DEFAULT nextval('blacklists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY captchas ALTER COLUMN id SET DEFAULT nextval('captchas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY checks ALTER COLUMN id SET DEFAULT nextval('checks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY ckeditor_assets ALTER COLUMN id SET DEFAULT nextval('ckeditor_assets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY coach_docs ALTER COLUMN id SET DEFAULT nextval('coach_docs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY comment_images ALTER COLUMN id SET DEFAULT nextval('comment_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY company_coaches ALTER COLUMN id SET DEFAULT nextval('company_coaches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY company_shops ALTER COLUMN id SET DEFAULT nextval('company_shops_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY concerneds ALTER COLUMN id SET DEFAULT nextval('concerneds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY coupons ALTER COLUMN id SET DEFAULT nextval('coupons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY course_abstracts ALTER COLUMN id SET DEFAULT nextval('course_abstracts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY course_addresses ALTER COLUMN id SET DEFAULT nextval('course_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY course_photos ALTER COLUMN id SET DEFAULT nextval('course_photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY courses ALTER COLUMN id SET DEFAULT nextval('courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY crawl_data ALTER COLUMN id SET DEFAULT nextval('crawl_data_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY devices ALTER COLUMN id SET DEFAULT nextval('devices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY dynamic_comments ALTER COLUMN id SET DEFAULT nextval('dynamic_comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY dynamic_films ALTER COLUMN id SET DEFAULT nextval('dynamic_films_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY dynamic_images ALTER COLUMN id SET DEFAULT nextval('dynamic_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY dynamics ALTER COLUMN id SET DEFAULT nextval('dynamics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY expiries ALTER COLUMN id SET DEFAULT nextval('expiries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY feedbacks ALTER COLUMN id SET DEFAULT nextval('feedbacks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY galleries ALTER COLUMN id SET DEFAULT nextval('galleries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY gallery_images ALTER COLUMN id SET DEFAULT nextval('gallery_images_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY group_members ALTER COLUMN id SET DEFAULT nextval('group_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY group_photos ALTER COLUMN id SET DEFAULT nextval('group_photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY group_places ALTER COLUMN id SET DEFAULT nextval('group_places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY groups ALTER COLUMN id SET DEFAULT nextval('groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY hit_reports ALTER COLUMN id SET DEFAULT nextval('hit_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY hits ALTER COLUMN id SET DEFAULT nextval('hits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY lessons ALTER COLUMN id SET DEFAULT nextval('lessons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY likes ALTER COLUMN id SET DEFAULT nextval('likes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY mass_message_groups ALTER COLUMN id SET DEFAULT nextval('mass_message_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY mass_messages ALTER COLUMN id SET DEFAULT nextval('mass_messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY news ALTER COLUMN id SET DEFAULT nextval('news_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY online_reports ALTER COLUMN id SET DEFAULT nextval('online_reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY onlines ALTER COLUMN id SET DEFAULT nextval('onlines_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY order_items ALTER COLUMN id SET DEFAULT nextval('order_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY overviews ALTER COLUMN id SET DEFAULT nextval('overviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY photos ALTER COLUMN id SET DEFAULT nextval('photos_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY places ALTER COLUMN id SET DEFAULT nextval('places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY recommends ALTER COLUMN id SET DEFAULT nextval('recommends_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY retentions ALTER COLUMN id SET DEFAULT nextval('retentions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY service_courses ALTER COLUMN id SET DEFAULT nextval('service_courses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY service_members ALTER COLUMN id SET DEFAULT nextval('service_members_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY showtimes ALTER COLUMN id SET DEFAULT nextval('showtimes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY skus ALTER COLUMN id SET DEFAULT nextval('skus_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY tracks ALTER COLUMN id SET DEFAULT nextval('tracks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY transactions ALTER COLUMN id SET DEFAULT nextval('transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY type_shows ALTER COLUMN id SET DEFAULT nextval('type_shows_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY wallet_logs ALTER COLUMN id SET DEFAULT nextval('wallet_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY wallets ALTER COLUMN id SET DEFAULT nextval('wallets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: mxing_v2
--

ALTER TABLE ONLY withdraws ALTER COLUMN id SET DEFAULT nextval('withdraws_id_seq'::regclass);


--
-- Data for Name: active_admin_comments; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY active_admin_comments (id, namespace, body, resource_id, resource_type, author_id, author_type, created_at, updated_at) FROM stdin;
\.


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('active_admin_comments_id_seq', 1, false);


--
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY activities (id, title, cover, address, group_id, created_at, updated_at, content, start_date, end_date, activity_type, theme, pos) FROM stdin;
4	最新活动	2015/07/17/bd9fd621-fffb-4606-93f5-cd46b1e7d77e.jpg	\N	\N	2015-07-17 01:53:44.239425	2015-07-17 01:53:44.239425	<p>啊啊三大到</p>\r\n	\N	\N	\N	\N	0
\.


--
-- Name: activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('activities_id_seq', 4, true);


--
-- Data for Name: address_coordinates; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY address_coordinates (id, address_id, lonlat) FROM stdin;
\.


--
-- Name: address_coordinates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('address_coordinates_id_seq', 1, false);


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY addresses (id, coach_id, venues, city, address, created_at, updated_at) FROM stdin;
1	\N	银城大厦店	上海市	中山西路933号	2015-06-15 09:08:53.299856	2015-06-15 09:08:53.299856
\.


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('addresses_id_seq', 1, true);


--
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY admin_users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, role, service_id) FROM stdin;
4	junwei@e-mxing.com	$2a$10$kfOApB8SHGxSFuKNIlk0sevmHwKOY57npuP0l/GXBCTGqhgnqS3Ry	\N	\N	\N	3	2015-08-14 02:11:41.844925	2015-07-25 08:17:25.693632	::1	192.168.0.130	2015-07-25 08:07:49.337273	2015-08-14 02:11:41.845823	1	89
1	admin@example.com	$2a$10$ZaS0QErVU7w6012D.1FPue7bkI5huWEcdD0BfnqdSU6TyA7wWFgcW	\N	\N	\N	442	2015-10-27 03:34:07.11038	2015-10-27 02:32:12.460155	::1	::1	2015-03-20 03:14:03.403486	2015-10-27 03:34:07.111288	0	\N
2	313423716@qq.com	$2a$10$Qg/495ePafql1gG2xz5oAOAOU2Ks7QBTUJab9NTSm/XHRezClR2ba	\N	\N	\N	77	2015-10-27 06:38:20.373955	2015-10-26 02:11:45.413275	::1	::1	2015-04-23 09:08:47.514303	2015-10-27 06:38:20.375011	3	81
3	hr@e-mxing.com	$2a$10$KFPvlzLgFXqkqgFVxzS4fuTli.0g/1ql/JjhtJhft.sLFHXUjO6Mi	\N	\N	\N	28	2015-07-20 06:30:09.379267	2015-07-16 02:13:41.740491	::1	127.0.0.1	2015-07-15 09:16:55.671718	2015-07-20 06:30:09.380019	4	89
\.


--
-- Name: admin_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('admin_users_id_seq', 4, true);


--
-- Data for Name: ads; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY ads (id, image, url, from_date, end_date) FROM stdin;
\.


--
-- Name: ads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('ads_id_seq', 1, false);


--
-- Data for Name: applies; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY applies (id, activity_id, user_id, created_at, updated_at) FROM stdin;
1	3	4	2015-04-21 07:06:42.938481	2015-04-21 07:06:42.938481
2	3	15	2015-04-21 08:27:26.567688	2015-04-21 08:27:26.567688
3	3	4	2015-04-23 03:04:46.995414	2015-04-23 03:04:46.995414
4	3	4	2015-04-23 03:06:07.106403	2015-04-23 03:06:07.106403
5	3	4	2015-04-23 03:06:28.565765	2015-04-23 03:06:28.565765
6	3	4	2015-04-23 03:07:27.363356	2015-04-23 03:07:27.363356
7	3	4	2015-04-23 03:07:48.102509	2015-04-23 03:07:48.102509
8	3	4	2015-04-23 03:07:57.204601	2015-04-23 03:07:57.204601
9	3	4	2015-04-23 03:08:10.134393	2015-04-23 03:08:10.134393
10	3	4	2015-04-23 03:08:13.754867	2015-04-23 03:08:13.754867
\.


--
-- Name: applies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('applies_id_seq', 10, true);


--
-- Data for Name: appointment_settings; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY appointment_settings (id, coach_id, start_date, "time", address_id, repeat, course_name, course_type, place, created_at, updated_at) FROM stdin;
\.


--
-- Name: appointment_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('appointment_settings_id_seq', 1, false);


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY appointments (id, coach_id, user_id, course_id, amount, status, created_at, updated_at, sku, code) FROM stdin;
1	\N	\N	\N	\N	\N	2015-07-01 12:09:42.894748	2015-07-01 12:09:42.894748	\N	\N
\.


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('appointments_id_seq', 1, true);


--
-- Data for Name: auto_logins; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY auto_logins (id, user_id, device, created_at, updated_at) FROM stdin;
\.


--
-- Name: auto_logins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('auto_logins_id_seq', 1, false);


--
-- Data for Name: banners; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY banners (id, image, url, start_date, end_date, type, link_id) FROM stdin;
1	2015/03/26/e2b4422d-cd9e-4370-8373-8f3fa9f1c247.jpg	http://www.baidu.com	2015-03-01	2015-03-31	\N	\N
2	2015/10/16/9e910a84-9e2f-46bd-b34c-e3a63baa831a.jpg	http://www.baidu.com	2015-02-10	\N	11	\N
\.


--
-- Name: banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('banners_id_seq', 2, true);


--
-- Data for Name: black_lists; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY black_lists (id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: black_lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('black_lists_id_seq', 1, false);


--
-- Data for Name: blacklists; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY blacklists (id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: blacklists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('blacklists_id_seq', 1, false);


--
-- Data for Name: captchas; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY captchas (id, mobile, captcha, created_at, updated_at) FROM stdin;
1	18516691251	\N	2015-03-29 08:00:32.99439	2015-03-29 08:00:32.99439
2	18516691251	509374	2015-03-29 08:03:27.284201	2015-03-29 08:03:27.284201
3	18516691251	824017	2015-03-29 09:06:38.476404	2015-03-29 09:06:38.476404
4	13391078500	173402	2015-04-04 09:43:31.511217	2015-04-04 09:43:31.511217
5	15502179520	107826	2015-04-04 09:56:12.47435	2015-04-04 09:56:12.47435
6	18768895205	961702	2015-04-04 10:11:04.731471	2015-04-04 10:11:04.731471
7	18768895205	738249	2015-04-07 01:38:24.279115	2015-04-07 01:38:24.279115
8	18768895205	391625	2015-04-07 02:21:52.026058	2015-04-07 02:21:52.026058
9	18768895205	784506	2015-04-07 02:25:16.46326	2015-04-07 02:25:16.46326
10	18768895205	160479	2015-04-07 02:38:49.345881	2015-04-07 02:38:49.345881
11	18768895205	091538	2015-04-07 02:51:42.14481	2015-04-07 02:51:42.14481
12	18768895205	315280	2015-04-07 03:09:30.838321	2015-04-07 03:09:30.838321
13	18768895205	752163	2015-04-07 03:17:30.039793	2015-04-07 03:17:30.039793
14	18768895205	931542	2015-04-07 03:21:33.441577	2015-04-07 03:21:33.441577
15	18768895205	370926	2015-04-07 03:26:36.062492	2015-04-07 03:26:36.062492
16	18768895205	609384	2015-04-07 03:33:49.743689	2015-04-07 03:33:49.743689
17	18768895205	845036	2015-04-07 04:02:28.759	2015-04-07 04:02:28.759
18	18768895205	671549	2015-04-07 04:05:44.862995	2015-04-07 04:05:44.862995
19	18768895205	189425	2015-04-07 04:07:05.662215	2015-04-07 04:07:05.662215
20	18768895205	905781	2015-04-07 04:08:12.124635	2015-04-07 04:08:12.124635
21	18768895205	678194	2015-04-07 04:13:32.323664	2015-04-07 04:13:32.323664
22	I love you so much fun and 	841975	2015-04-07 04:39:35.112154	2015-04-07 04:39:35.112154
23	18768895205	573142	2015-04-07 04:44:57.28756	2015-04-07 04:44:57.28756
24	18768895205 	589734	2015-04-07 04:47:33.825276	2015-04-07 04:47:33.825276
25	18768895205 	493165	2015-04-07 04:51:03.174639	2015-04-07 04:51:03.174639
26	13040649215	453298	2015-04-07 06:31:10.944203	2015-04-07 06:31:10.944203
27	12345	618543	2015-04-07 06:43:06.058248	2015-04-07 06:43:06.058248
28	21312	385209	2015-04-07 06:44:17.244135	2015-04-07 06:44:17.244135
29	adad	205794	2015-04-07 06:53:28.486521	2015-04-07 06:53:28.486521
30	eqe	369527	2015-04-07 06:55:08.134182	2015-04-07 06:55:08.134182
31	eqe	512693	2015-04-07 06:55:11.805352	2015-04-07 06:55:11.805352
32	q23121	045832	2015-04-07 07:06:58.098098	2015-04-07 07:06:58.098098
33	wefwef	921684	2015-04-07 07:08:28.934782	2015-04-07 07:08:28.934782
34	wefwef	674219	2015-04-07 07:08:58.831508	2015-04-07 07:08:58.831508
35	7	302895	2015-04-07 07:11:30.083989	2015-04-07 07:11:30.083989
36	232	987106	2015-04-07 07:12:17.099017	2015-04-07 07:12:17.099017
37	312	071698	2015-04-07 07:12:44.393647	2015-04-07 07:12:44.393647
38	21	956734	2015-04-07 07:20:16.772493	2015-04-07 07:20:16.772493
39	qwq	578901	2015-04-07 07:21:39.853119	2015-04-07 07:21:39.853119
40	qwq	397154	2015-04-07 07:21:42.242308	2015-04-07 07:21:42.242308
41	qwq	341269	2015-04-07 07:21:44.40272	2015-04-07 07:21:44.40272
42	qwd	408157	2015-04-07 07:24:03.373073	2015-04-07 07:24:03.373073
43	c	815402	2015-04-07 07:38:31.058275	2015-04-07 07:38:31.058275
44	c	497061	2015-04-07 07:38:32.614373	2015-04-07 07:38:32.614373
45	c	351087	2015-04-07 07:38:33.753508	2015-04-07 07:38:33.753508
46	c	134890	2015-04-07 07:38:35.112779	2015-04-07 07:38:35.112779
47	312	732419	2015-04-07 07:38:53.591702	2015-04-07 07:38:53.591702
48	312	054872	2015-04-07 07:38:55.334302	2015-04-07 07:38:55.334302
49	312	873021	2015-04-07 07:38:56.634039	2015-04-07 07:38:56.634039
50	312	253618	2015-04-07 07:39:00.604046	2015-04-07 07:39:00.604046
51	hj	781532	2015-04-07 07:39:49.849082	2015-04-07 07:39:49.849082
52	12e	134978	2015-04-07 07:41:34.59514	2015-04-07 07:41:34.59514
53	2e	816245	2015-04-07 07:43:50.492168	2015-04-07 07:43:50.492168
54	gh	695710	2015-04-07 07:59:51.280664	2015-04-07 07:59:51.280664
55	eqw	549287	2015-04-07 08:11:47.50913	2015-04-07 08:11:47.50913
56	qewe	931807	2015-04-07 08:12:51.144553	2015-04-07 08:12:51.144553
57	18768895205	360489	2015-04-07 08:23:17.746934	2015-04-07 08:23:17.746934
58	18768895205	874592	2015-04-07 08:24:49.546039	2015-04-07 08:24:49.546039
59	18768895205	073241	2015-04-07 08:26:32.525334	2015-04-07 08:26:32.525334
60	18768895205	824651	2015-04-07 08:29:03.892849	2015-04-07 08:29:03.892849
61	18768895205	387569	2015-04-07 08:31:24.214281	2015-04-07 08:31:24.214281
62	18768895205	258790	2015-04-07 08:32:56.863268	2015-04-07 08:32:56.863268
63	66	075923	2015-04-07 08:39:56.218791	2015-04-07 08:39:56.218791
64	66	870495	2015-04-07 08:42:36.750472	2015-04-07 08:42:36.750472
65	qws	610982	2015-04-07 08:48:45.251254	2015-04-07 08:48:45.251254
66	qws	807125	2015-04-07 08:49:47.693066	2015-04-07 08:49:47.693066
67	qws	147923	2015-04-07 08:50:53.433842	2015-04-07 08:50:53.433842
68	dd	653407	2015-04-07 08:51:57.053887	2015-04-07 08:51:57.053887
69	dd	024986	2015-04-07 08:54:19.058866	2015-04-07 08:54:19.058866
70	qwewq	024816	2015-04-07 09:27:00.366015	2015-04-07 09:27:00.366015
71	18768895205	234786	2015-04-07 09:35:01.135484	2015-04-07 09:35:01.135484
72	qeqw	269471	2015-04-07 09:42:43.933969	2015-04-07 09:42:43.933969
73	qw	657439	2015-04-07 09:44:16.705124	2015-04-07 09:44:16.705124
74	w	670183	2015-04-07 09:46:30.343822	2015-04-07 09:46:30.343822
75	das	932470	2015-04-07 09:53:34.018659	2015-04-07 09:53:34.018659
76	18768895205	342607	2015-04-07 10:13:22.790347	2015-04-07 10:13:22.790347
77	qweq	816293	2015-04-07 10:17:52.154788	2015-04-07 10:17:52.154788
78	qweqw	516439	2015-04-07 10:19:28.844452	2015-04-07 10:19:28.844452
79	18768895205	863754	2015-04-07 10:20:33.523031	2015-04-07 10:20:33.523031
80	18768895205	790128	2015-04-07 10:23:02.096072	2015-04-07 10:23:02.096072
81	18768895205	053981	2015-04-07 10:27:06.552963	2015-04-07 10:27:06.552963
82	18768895205	905136	2015-04-07 10:30:02.78286	2015-04-07 10:30:02.78286
83	18768895205	748230	2015-04-07 10:32:04.635086	2015-04-07 10:32:04.635086
84	18768895205	685903	2015-04-07 10:32:04.754872	2015-04-07 10:32:04.754872
85	18768895205	948071	2015-04-07 10:32:04.884621	2015-04-07 10:32:04.884621
86	18768895205	971430	2015-04-07 10:32:05.040858	2015-04-07 10:32:05.040858
87	18768895205	324195	2015-04-07 10:32:05.157384	2015-04-07 10:32:05.157384
88	18768895205	375692	2015-04-07 10:36:04.376972	2015-04-07 10:36:04.376972
89	18768895205	710298	2015-04-08 01:38:21.655475	2015-04-08 01:38:21.655475
90	2132123	314958	2015-04-08 01:40:18.794857	2015-04-08 01:40:18.794857
91	15026637572	810465	2015-04-08 01:48:33.663956	2015-04-08 01:48:33.663956
92	18768895205	584032	2015-04-08 02:30:20.171769	2015-04-08 02:30:20.171769
93	18768895205	531269	2015-04-08 02:39:36.641279	2015-04-08 02:39:36.641279
94	12312	483271	2015-04-08 02:43:12.932124	2015-04-08 02:43:12.932124
95	15026637572	504891	2015-04-08 08:26:06.890838	2015-04-08 08:26:06.890838
96	15026637572	271950	2015-04-08 10:23:44.880431	2015-04-08 10:23:44.880431
97	18768895205	643127	2015-04-08 10:23:45.562418	2015-04-08 10:23:45.562418
98	1502663757	650839	2015-04-08 10:24:08.973889	2015-04-08 10:24:08.973889
99	150266375	134829	2015-04-08 10:24:22.001631	2015-04-08 10:24:22.001631
100	15026637	072436	2015-04-08 10:24:32.673746	2015-04-08 10:24:32.673746
101	15026637	720958	2015-04-08 10:24:50.996194	2015-04-08 10:24:50.996194
102	18768895205	584092	2015-04-08 10:25:14.686109	2015-04-08 10:25:14.686109
103	18768895205	956407	2015-04-08 10:27:12.761091	2015-04-08 10:27:12.761091
104		905843	2015-04-08 10:28:59.07325	2015-04-08 10:28:59.07325
105	18768895205	092348	2015-04-08 10:38:17.628357	2015-04-08 10:38:17.628357
106	18768895205	214675	2015-04-08 10:44:32.683866	2015-04-08 10:44:32.683866
107	18768895205	492153	2015-04-08 10:49:13.805934	2015-04-08 10:49:13.805934
108	18768895205	928043	2015-04-08 10:53:52.255397	2015-04-08 10:53:52.255397
109	18768895205	132497	2015-04-08 10:55:37.163086	2015-04-08 10:55:37.163086
110	18768895205	302567	2015-04-09 01:26:47.561072	2015-04-09 01:26:47.561072
111	13391078500	534672	2015-04-09 01:38:44.524067	2015-04-09 01:38:44.524067
112	18768895205	281346	2015-04-09 01:38:58.524878	2015-04-09 01:38:58.524878
113	1876889520	391264	2015-04-09 02:29:14.84435	2015-04-09 02:29:14.84435
114	18221058659	574603	2015-04-09 02:31:51.901614	2015-04-09 02:31:51.901614
115	111	627950	2015-04-09 02:44:57.147348	2015-04-09 02:44:57.147348
116	18768895205	348196	2015-04-09 02:45:30.143703	2015-04-09 02:45:30.143703
117	123123	152783	2015-04-09 02:48:38.013115	2015-04-09 02:48:38.013115
118	18768895205	740321	2015-04-09 02:49:32.444544	2015-04-09 02:49:32.444544
119	18768895205	802351	2015-04-09 02:51:23.649489	2015-04-09 02:51:23.649489
120	18768895205	204391	2015-04-09 02:52:28.71195	2015-04-09 02:52:28.71195
121	18768895205	403571	2015-04-09 02:54:01.078842	2015-04-09 02:54:01.078842
122	15026637572	891607	2015-04-09 02:57:16.545669	2015-04-09 02:57:16.545669
123	18768895205	793165	2015-04-09 02:57:36.184063	2015-04-09 02:57:36.184063
124	18768895205	301625	2015-04-09 02:59:18.515099	2015-04-09 02:59:18.515099
125	18768895205	697503	2015-04-09 03:00:42.330874	2015-04-09 03:00:42.330874
126	18768895205	382061	2015-04-09 03:01:51.612002	2015-04-09 03:01:51.612002
127	18768895205	017592	2015-04-09 03:03:06.40354	2015-04-09 03:03:06.40354
128	18768895205	173924	2015-04-09 03:07:53.151003	2015-04-09 03:07:53.151003
129	18768895205	214968	2015-04-09 03:08:23.183818	2015-04-09 03:08:23.183818
130	18768895205	714089	2015-04-09 03:08:51.513363	2015-04-09 03:08:51.513363
132	18768895205	965103	2015-04-09 03:11:05.91408	2015-04-09 03:11:05.91408
133	18768895205	958631	2015-04-09 03:12:00.964393	2015-04-09 03:12:00.964393
134	18768895205	785691	2015-04-09 03:12:44.463178	2015-04-09 03:12:44.463178
135	18768895205	062157	2015-04-09 03:13:44.107021	2015-04-09 03:13:44.107021
138	13391078500	406723	2015-04-09 03:24:51.078487	2015-04-09 03:24:51.078487
141	18768895205	862039	2015-04-09 03:37:46.00393	2015-04-09 03:37:46.00393
145	1234567	021657	2015-04-09 08:06:17.915164	2015-04-09 08:06:17.915164
149	2	048723	2015-04-09 08:14:33.362594	2015-04-09 08:14:33.362594
151	4	047918	2015-04-09 08:17:56.723342	2015-04-09 08:17:56.723342
152	5	437028	2015-04-09 08:19:00.485261	2015-04-09 08:19:00.485261
153	11	983452	2015-04-09 08:21:54.200179	2015-04-09 08:21:54.200179
154	22	128305	2015-04-09 08:24:49.324826	2015-04-09 08:24:49.324826
155	33	278314	2015-04-09 08:26:14.502158	2015-04-09 08:26:14.502158
157	21	605293	2015-04-09 08:42:49.288716	2015-04-09 08:42:49.288716
160	7	319278	2015-04-09 09:08:07.922084	2015-04-09 09:08:07.922084
161	7	412563	2015-04-09 09:08:40.743359	2015-04-09 09:08:40.743359
163	2132124	679308	2015-04-09 11:07:16.861803	2015-04-09 11:07:16.861803
164	15617656314	908172	2015-04-09 11:08:49.618578	2015-04-09 11:08:49.618578
166	12312312321	296450	2015-04-09 11:22:07.636808	2015-04-09 11:22:07.636808
131	18768895205	748623	2015-04-09 03:09:55.073737	2015-04-09 03:09:55.073737
136	18768895205	850273	2015-04-09 03:14:14.602825	2015-04-09 03:14:14.602825
137	13391078500	017485	2015-04-09 03:20:57.580032	2015-04-09 03:20:57.580032
139	13391078500	201875	2015-04-09 03:26:33.753363	2015-04-09 03:26:33.753363
140	13391078500	386512	2015-04-09 03:32:55.701812	2015-04-09 03:32:55.701812
142	13391078500	560193	2015-04-09 05:03:17.449565	2015-04-09 05:03:17.449565
143	15617656313	352406	2015-04-09 05:53:17.982537	2015-04-09 05:53:17.982537
144	1213133113	763541	2015-04-09 07:42:06.1492	2015-04-09 07:42:06.1492
146	1234	495613	2015-04-09 08:07:21.533818	2015-04-09 08:07:21.533818
147	123	718034	2015-04-09 08:10:24.67388	2015-04-09 08:10:24.67388
148	1	310478	2015-04-09 08:13:33.247313	2015-04-09 08:13:33.247313
150	3	870245	2015-04-09 08:16:55.785157	2015-04-09 08:16:55.785157
156	121	759326	2015-04-09 08:28:47.976551	2015-04-09 08:28:47.976551
158	13	450872	2015-04-09 08:43:58.07351	2015-04-09 08:43:58.07351
159	1	359640	2015-04-09 08:52:39.685955	2015-04-09 08:52:39.685955
162	13585753578	042853	2015-04-09 10:04:55.829785	2015-04-09 10:04:55.829785
165	11111111111	716539	2015-04-09 11:12:16.569023	2015-04-09 11:12:16.569023
167	11111111112	082473	2015-04-09 11:23:19.894761	2015-04-09 11:23:19.894761
168	22222222222	738126	2015-04-09 11:25:09.372773	2015-04-09 11:25:09.372773
169	11111111112	093648	2015-04-09 11:26:13.005042	2015-04-09 11:26:13.005042
170	13585753570	851423	2015-04-09 11:28:51.982904	2015-04-09 11:28:51.982904
171	13585753578	469371	2015-04-09 11:32:00.123726	2015-04-09 11:32:00.123726
172	23131232132	053297	2015-04-09 11:43:09.020537	2015-04-09 11:43:09.020537
173	99999999999	763201	2015-04-09 12:00:53.673234	2015-04-09 12:00:53.673234
174	99999999999	295470	2015-04-10 02:04:14.581383	2015-04-10 02:04:14.581383
175	77777777777	807961	2015-04-10 02:05:37.484579	2015-04-10 02:05:37.484579
176	11111111114	209648	2015-04-10 02:09:04.414337	2015-04-10 02:09:04.414337
177	88888888888	198543	2015-04-10 02:11:59.456421	2015-04-10 02:11:59.456421
178	23232323232	950263	2015-04-10 02:13:22.111456	2015-04-10 02:13:22.111456
179	11111111111	624057	2015-04-10 02:15:02.871182	2015-04-10 02:15:02.871182
180	11111111112	829614	2015-04-15 05:46:35.199928	2015-04-15 05:46:35.199928
181	11111111112	308276	2015-04-15 05:47:37.207231	2015-04-15 05:47:37.207231
182	11111111112	825930	2015-04-15 05:48:00.62747	2015-04-15 05:48:00.62747
183	11111111111	354917	2015-04-15 05:51:03.183046	2015-04-15 05:51:03.183046
184	11111111111	530684	2015-04-15 05:54:36.986765	2015-04-15 05:54:36.986765
185	11111111111	269754	2015-04-15 05:56:38.284758	2015-04-15 05:56:38.284758
186	11111111111	863217	2015-04-15 05:58:47.062231	2015-04-15 05:58:47.062231
187	15502179520	870293	2015-04-15 06:59:11.529099	2015-04-15 06:59:11.529099
188	12345678978	934258	2015-04-20 02:54:20.482711	2015-04-20 02:54:20.482711
\.


--
-- Name: captchas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('captchas_id_seq', 188, true);


--
-- Data for Name: checks; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY checks (id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: checks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('checks_id_seq', 1, false);


--
-- Data for Name: ckeditor_assets; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY ckeditor_assets (id, data_file_name, data_content_type, data_file_size, assetable_id, assetable_type, type, width, height, created_at, updated_at) FROM stdin;
\.


--
-- Name: ckeditor_assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('ckeditor_assets_id_seq', 3, true);


--
-- Data for Name: coach_docs; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY coach_docs (id, coach_id, image) FROM stdin;
\.


--
-- Name: coach_docs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('coach_docs_id_seq', 1, false);


--
-- Data for Name: comment_images; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY comment_images (id, comment_id, image) FROM stdin;
\.


--
-- Name: comment_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('comment_images_id_seq', 1, false);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY comments (id, user_id, content, created_at, updated_at, score, sku, image) FROM stdin;
\.


--
-- Name: comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('comments_id_seq', 1, false);


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY companies (id, name, avatar, description, created_at, updated_at) FROM stdin;
\.


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('companies_id_seq', 1, false);


--
-- Data for Name: company_coaches; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY company_coaches (id, company_id, coach_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: company_coaches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('company_coaches_id_seq', 1, false);


--
-- Data for Name: company_shops; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY company_shops (id, company_id, shop_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: company_shops_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('company_shops_id_seq', 1, false);


--
-- Data for Name: concerneds; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY concerneds (id, course_id, user_id, created_at, updated_at) FROM stdin;
2	1	4	2015-06-29 03:54:07.909106	2015-06-29 03:54:07.909106
\.


--
-- Name: concerneds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('concerneds_id_seq', 2, true);


--
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY coupons (id, no, name, discount, info, start_date, end_date, limit_category, limit_ext, min, active, created_at, updated_at, code, amount, lock_version, used) FROM stdin;
4	\N	1	10.0	1	2015-01-08	2015-01-09	1	\N	100	\N	2015-08-20 07:31:33.812358	2015-08-20 07:31:33.812358	{}	11	0	0
5	\N	2	2.0	11	2015-08-01	2015-08-31	1	\N	1	\N	2015-08-20 07:36:11.709944	2015-08-20 07:36:11.709944	{}	10	0	0
\.


--
-- Name: coupons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('coupons_id_seq', 5, true);


--
-- Data for Name: course_abstracts; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY course_abstracts (id, course_id, address_id, coach_id, coach_gender, course_price, course_type, coordinate) FROM stdin;
\.


--
-- Name: course_abstracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('course_abstracts_id_seq', 1, false);


--
-- Data for Name: course_addresses; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY course_addresses (id, course_id, address_id, created_at, updated_at) FROM stdin;
1	1	1	2015-06-16 08:23:10.84391	2015-06-16 08:23:10.84391
2	2	1	2015-06-16 08:23:22.608434	2015-06-16 08:23:22.608434
3	3	1	2015-06-16 08:23:26.344298	2015-06-16 08:23:26.344298
4	4	1	2015-06-16 08:23:32.376339	2015-06-16 08:23:32.376339
5	5	1	2015-06-16 08:23:35.896157	2015-06-16 08:23:35.896157
6	6	1	2015-06-16 08:23:39.673404	2015-06-16 08:23:39.673404
7	7	1	2015-06-16 08:23:43.816317	2015-06-16 08:23:43.816317
8	8	1	2015-06-16 08:23:48.896373	2015-06-16 08:23:48.896373
9	9	1	2015-06-16 08:23:52.608485	2015-06-16 08:23:52.608485
10	10	1	2015-06-16 08:23:56.813082	2015-06-16 08:23:56.813082
11	11	1	2015-06-16 08:24:00.883483	2015-06-16 08:24:00.883483
12	12	1	2015-06-16 08:24:03.88051	2015-06-16 08:24:03.88051
13	13	1	2015-06-16 08:24:06.872285	2015-06-16 08:24:06.872285
14	14	1	2015-06-16 08:24:10.21641	2015-06-16 08:24:10.21641
15	15	1	2015-06-16 08:24:13.992407	2015-06-16 08:24:13.992407
16	16	1	2015-06-16 08:24:17.936493	2015-06-16 08:24:17.936493
17	17	1	2015-06-16 08:24:21.512303	2015-06-16 08:24:21.512303
18	18	1	2015-06-16 08:24:25.304444	2015-06-16 08:24:25.304444
19	19	1	2015-06-16 08:24:29.160266	2015-06-16 08:24:29.160266
20	20	1	2015-06-16 08:25:59.112406	2015-06-16 08:25:59.112406
21	21	1	2015-06-16 08:26:02.328376	2015-06-16 08:26:02.328376
22	22	1	2015-06-16 08:26:05.296227	2015-06-16 08:26:05.296227
23	23	1	2015-06-16 08:26:08.888459	2015-06-16 08:26:08.888459
24	24	1	2015-06-16 08:26:12.976317	2015-06-16 08:26:12.976317
25	25	1	2015-06-16 08:26:16.767965	2015-06-16 08:26:16.767965
26	26	1	2015-06-16 08:26:20.360383	2015-06-16 08:26:20.360383
27	26	1	2015-06-16 08:27:12.137736	2015-06-16 08:27:12.137736
\.


--
-- Name: course_addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('course_addresses_id_seq', 27, true);


--
-- Data for Name: course_photos; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY course_photos (id, course_id, photo, created_at, updated_at) FROM stdin;
\.


--
-- Name: course_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('course_photos_id_seq', 1, false);


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY courses (id, coach_id, name, type, style, during, price, exp, proposal, intro, customized, custom_mxid, custom_mobile, top, status, created_at, updated_at, address, guarantee, comments_count, concerns_count, order_items_count, special, image) FROM stdin;
2	110	新科城	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2015-07-07 07:06:23.009821	2015-07-09 04:29:55.870377	{}	0	0	0	20		{}
1	110	课程1	\N	\N	\N	101	\N	\N	\N	\N	\N	\N	1	1	2015-06-15 09:10:11.981011	2015-07-13 08:38:41.048432	{1,2}	0	0	1	0		{}
\.


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('courses_id_seq', 2, true);


--
-- Data for Name: crawl_data; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY crawl_data (id, name, avatar, address, tel, business, service, photo, created_at, updated_at) FROM stdin;
155	V Lines私人教练工作室(望京旗舰店	http://i3.s1.dpfile.com/pc/f3e39388325e59facaacd0c8f30a1f84(249x249)/thumb.jpg	\n    朝阳区望京园悠乐汇A5区2层(方恒购物，新世界百货，望京soho, 地铁望京南站	["010-5945184", "1326109535"]	9：00-22：0	{健身(7}	{http://i3.s1.dpfile.com/pc/5f811276c586e36d8b430807dcac8fc7(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/41973566346e1ee574a8bc9e51e6dca5(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/93f5da086c9db1298c188a963d9e9186(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/df3395d8bf5f1ef610e6588a98fddf9a(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/4607700cfcb726012d10b3500322fc1b(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/a47cc1c219d30ecc67cf26773bc4e9f8(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/75d00a1291a7fe48ffe7060b0afbc54a(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/d3b80f0f5a6a43b8bc39730f14a6d262(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/83a395973f7e8534ff3c7e119d28abd5(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/0fd9ecc48a1a2ec07dbc8d9793615271(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/8c9716f2e7c8accacd0360c62a168785(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/8bd8cd37e841d070fa92422460ca466a(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/174964f3a4e6ba61027af9a87101e48b(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/2ae7b4de5f909e762bc6bcbea6e812ff(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/f726b611892e551a88d473f5b4dd9577(240c180)/thumb.jpg}	2015-10-26 12:21:52.125068	2015-10-26 12:21:52.125068
156	一小时健身营养工作室(华彩国际公寓店	http://i1.s1.dpfile.com/pc/681e93115dbbd6bf9d9e7d856b235909(249x249)/thumb.jpg	\n    朝阳区望京广顺北大街华彩国际公寓18号院1号楼1单元1001室(（近华彩商业中心，六佰本商业中心对面）	["1884516371", "1520139844"]	24小时营业	{健身(3}	{http://i1.s1.dpfile.com/pc/d2a76a2d814acf2fa32fbd23c3ac0f5f(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/1ce2fd579e47a8bf7044ee46b015bab9(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/a0c9050b335fd9c03d9d70f0efe580bb(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/f2460d05b77e1854043fc3b6c5e9d9bd(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/f4eaf215dd4c6e874bee3c6fbafbb020(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/e671e74fc15768192e9ff1432730c939(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/9cb1f5f1354402a3365156ba0cf7c564(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/3e53e18761c792247d16421a3c7f9ca0(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/f7baad7d69061467ed42637e75588d5a(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/ba880fab364b838d2e2106cf9f520c13(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/2f589e7a398d9f69124784abaf54a0ba(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/93f5f434ba9ce6ddd004b315993dea52(240c180)/thumb.jpg}	2015-10-26 12:22:10.023712	2015-10-26 12:22:10.023712
157	i Fitness Space私人教练工作室(朝外SOHO店	http://i1.s1.dpfile.com/pc/c69e579ef5afb9c858773e5a19c729d8(249x249)/thumb.jpg	\n    朝阳区朝外大街乙6号朝外SOHO B座0726(近CBD 世贸天阶 新城国际 尚都SOHO 蓝岛大厦	["010-5773138", "1861035990"]	09:00-22:00 周一,周二,周三,周四,周五,周六,周	{健身(28}	{http://i2.s1.dpfile.com/pc/c1c1bbc4c721227af5b33217d6bd4cb6(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/b9329151b89cdf5b17b755fa8fa52774(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/5caa0a5b36219a32f48b1efe16f1b427(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/be6675d6a1bd5d735bbd48819b00bc37(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/5bbc8481663181371cf4faf590381e74(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/5dd4310a0c69c6b23d4af473c5be1e9b(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/f00e90ed496eaef1da8da6e18260d16c(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/8f467b2b2ae2d0c32c970c850e2e3518(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/71e3375f50d0a05c34c1d779110a6b5d(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/5eab3241eef6db852d55add740b89849(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/05148eb78347c9458148527872246ba0(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/ddd49d75b4f665b6e240dc4fe0d14a17(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/202c21db80cd494bd4909aa643b59890(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/bccd1cb98d3d7054d4c504517cd73dd5(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/2053a34e65cb640ba04984ff3b5b6fd7(240c180)/thumb.jpg}	2015-10-26 12:22:30.43726	2015-10-26 12:22:30.43726
158	HappyPlus精品私教健身	http://i3.s1.dpfile.com/pc/0e98ad6d874160c1374011da38908a5c(249x249)/thumb.jpg	\n    朝阳区光华路22号光华路SOHO一期319(国贸 世贸天阶 世贸国际公寓 温莎大道 建外 LG双子座	["010-6561697", "1369327070"]	09：00—22：0	{健身(4}	{http://i3.s1.dpfile.com/pc/afade9e2869176e6ad32455ba956594f(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/8eb3c5c3f42fad63af6c69c0a11a202f(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/8452cc33d69f9d67efee04506014e5ea(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/f13bcb7eacbd1454e317c53dccfa0e92(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/68d13db3efd6875df3071bb5005e22e0(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/570ac543cc2a1ae57d8d0a2a8ca4c6a8(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/fa0822674c0c45642438fc276f50099d(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/b2d3a1843a5f88df6b6762aab589b92b(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/570ac543cc2a1ae57d8d0a2a8ca4c6a8(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/c67646fa1d7790c86d4b829f4e334f4f(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/8d383de7791b51643ad36fc33ec81f15(240c180)/thumb.jpg}	2015-10-26 12:22:48.994173	2015-10-26 12:22:48.994173
159	维斯塔健身Vista Fitness(大望路分店	http://i2.s1.dpfile.com/pc/0cd0a517344b2498b8e0c9739a27fa50(249x249)/thumb.jpg	\n    朝阳区建国路88号SOHO现代城A座3012	["010-5728292"]	09:00-22:00 周一,周二,周三,周四,周五,周六,周	{"健身(4)\n                        \n                    减肥(2)\n                        \n                    塑身(2"}	{http://i1.s1.dpfile.com/pc/64eb0d96dcd3fd7d46c9be21047b1aae(240c180)/thumb.jpg}	2015-10-26 12:23:09.454905	2015-10-26 12:23:09.454905
160	7+新概念健身(望京店	http://i3.s1.dpfile.com/pc/21a5101299422f1797cef6f17e9d342d(249x249)/thumb.jpg	\n    朝阳区望京soho塔二A座3层231	["010-5707675"]	10：00-22：0	{健身(4}	{http://i1.s1.dpfile.com/pc/436442626d332817cd8e441de91611d4(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/cfa6c0c79f4aa2b91665f85c4f5b9cd1(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/ab19dca41f13566ab5194110cda5334e(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/4756f10486dc633d9e489e386d7890a9(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/794228076f77a94584fc39e805b0823d(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/6fecc9dc22bbe524e4afd0260ae8eab7(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/aa66f3ca2464d4fb1cf2e9dfde465e72(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/7d5fe6f341ce72df59fc4b5f5ec68f3f(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/a81e92f2b2f372e55688a1a2619ef66e(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/40460378ab40ee28e4ae9fc0b0922316(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/bae4a43ea7b2a2f233a7d425c682a5df(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/fce7c0f028a0daa8544e357b854593e1(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/052abc8c66c7247f7c31681f32e248ca(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/64239fa7662bc5d60886bbeef1c697d8(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/6af167ebb821e0212ba4de0eb4f90493(240c180)/thumb.jpg}	2015-10-26 12:23:33.703646	2015-10-26 12:23:33.703646
161	里昂健身工作	http://i3.s1.dpfile.com/pc/43277ce7c037a2fab1b3c04fcd5c0718(249x249)/thumb.jpg	\n    朝阳区西大望路外企公寓2号楼2单元211(双井家乐福  金港国际  乐成公馆	["010-6772766", "1821076576"]	10:00----22:0	{健身(19}	{http://i3.s1.dpfile.com/pc/239cef4ea31eca3fc7e46ecb2fef916e(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/330407dc3e066723e21ecfb7d0aaa09c(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/2fa693cfde9ca997fc8fe46e8156d5a0(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/332455d1088556ee1ef6e036459d80e8(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/2bb395a2b9ada36cc15229e39a1040cd(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/9f26e9b4b5e2cfd2c98991a878b439ae(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/995762a00f94e6129044cb00182f0d52(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/5eff3aac87c5d679dbbf3e737fa4ee66(240c180)/thumb.jpg,http://i2.s1.dpfile.com/pc/9c7655a302e95686562a97e38c496aa5(240c180)/thumb.jpg,http://i3.s1.dpfile.com/pc/f09d150a2fca3ee0d402faaf940dc083(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/4dce82a3f7b17252ec18b0d4f4252960(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/5c7196f36c7df72e96b2f16e8a840680(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/d900bf7d226b16bc2efff8f50bcfce94(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/05a59dde707103d91f651ce7bcfb2c79(240c180)/thumb.jpg,http://i1.s1.dpfile.com/pc/1b5ec958e5648c448399061ba41430da(240c180)/thumb.jpg}	2015-10-26 12:23:51.00261	2015-10-26 12:23:51.00261
\.


--
-- Name: crawl_data_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('crawl_data_id_seq', 161, true);


--
-- Data for Name: devices; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY devices (id, name, system, device, channel, version, ip, token, created_at, updated_at) FROM stdin;
\.


--
-- Name: devices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('devices_id_seq', 1, false);


--
-- Data for Name: dynamic_comments; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY dynamic_comments (id, dynamic_id, user_id, content, created_at, updated_at) FROM stdin;
2	37	4	命令测试发表评论	2015-03-31 08:31:05.203696	2015-04-09 08:23:34.088212
3	40	4	测试评论1	2015-04-11 04:24:08.294573	2015-04-11 04:25:50.239771
4	40	4	测试评论2	2015-04-11 04:24:10.36715	2015-04-11 04:25:50.272998
5	40	4	测试评论3	2015-04-11 04:24:12.13502	2015-04-11 04:25:50.279821
6	40	4	测试评论4	2015-04-11 04:24:13.895047	2015-04-11 04:25:50.28803
7	40	4	测试评论5	2015-04-11 04:24:16.135877	2015-04-11 04:25:50.2963
8	40	4	测试评论6	2015-04-11 04:24:18.103747	2015-04-11 04:25:50.30467
9	40	4	测试评论677777777	2015-04-11 04:24:22.279015	2015-04-11 04:25:50.313261
10	40	4	测试评8888	2015-04-11 04:24:26.631065	2015-04-11 04:25:50.3226
11	\N	30	好	2015-04-14 07:36:43.561403	2015-04-14 07:36:43.561403
14	43	30	还是殊死搏斗伙伴不到爸爸的话很喜欢的话	2015-04-14 07:40:02.690497	2015-04-14 07:40:02.690497
15	43	30	道德败坏欢呼声好像不是时候爸爸不得不巴登巴登宝贝不到巴巴多斯吧巴西队吧。	2015-04-14 07:40:27.823096	2015-04-14 07:40:27.823096
16	43	30	我	2015-04-14 07:44:33.67693	2015-04-14 07:44:33.67693
17	43	30	这	2015-04-14 07:52:53.742521	2015-04-14 07:52:53.742521
18	43	30	不u 的活动我一定完全不同的心态过俄的主要原因是	2015-04-14 07:53:06.463594	2015-04-14 07:53:06.463594
19	43	30	电话电话电话号码是多少钱啊？这是我们最近有时候我	2015-04-14 07:53:17.714193	2015-04-14 07:53:17.714193
20	43	30	 当地法规	2015-04-14 08:26:00.105035	2015-04-14 08:26:00.105035
21	43	30	的方法	2015-04-14 08:27:56.382895	2015-04-14 08:27:56.382895
22	43	30	黑胡椒	2015-04-14 08:28:14.580517	2015-04-14 08:28:14.580517
23	42	30	我们	2015-04-14 10:18:07.714395	2015-04-14 10:18:07.714395
24	42	30	想到你	2015-04-14 10:18:15.173956	2015-04-14 10:18:15.173956
25	42	30	我	2015-04-14 10:18:19.673238	2015-04-14 10:18:19.673238
26	43	30	123456😉	2015-04-15 03:29:47.992116	2015-04-15 03:29:47.992116
27	37	38	是撒	2015-04-17 00:56:02.971949	2015-04-17 00:56:02.971949
28	37	38	😬	2015-04-17 00:56:47.17223	2015-04-17 00:56:47.17223
\.


--
-- Name: dynamic_comments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('dynamic_comments_id_seq', 28, true);


--
-- Data for Name: dynamic_films; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY dynamic_films (id, dynamic_id, cover, film, created_at, updated_at, title) FROM stdin;
5	6	2015/03/31/51e9cb4d-48af-48ab-8204-7c69a5293397.jpg	2015/03/31/e54ca740-9a05-485d-8e3e-9c81decf45f1.mp4	2015-03-31 01:58:20.143763	2015-03-31 01:58:20.143763	我的健身视频
6	14	2015/03/31/b0f973ce-8f7c-4086-ae2c-a01deaa24891.jpg	2015/03/31/fc7664a8-033f-471c-b38b-960591784058.mp4	2015-03-31 06:23:17.801963	2015-03-31 06:23:17.801963	\N
9	25	2015/04/09/b2fe5c11-d930-40bc-91f8-3faf4300dd5a.	2015/04/09/5dd89906-a6a9-4007-8569-856b87b6e1ff.	2015-04-09 02:46:45.269044	2015-04-09 02:46:45.269044	123456789
10	33	2015/04/09/7fe7f80d-1b21-4045-b7b7-53fe57eb5cac.	2015/04/09/78a6c5ab-f172-454c-be85-9e33310c5203.	2015-04-09 03:33:12.535066	2015-04-09 03:33:12.535066	\N
11	37	2015/04/09/cb545ed8-7d8f-4014-b99f-28e2dd5dc1a5.	2015/04/09/d4faf73b-5e7d-40a4-8a0d-30b827527b43.	2015-04-09 07:34:32.254581	2015-04-09 07:34:32.254581	把中饱私囊
12	38	2015/04/10/9662e049-52eb-4f77-86c0-70855622afe6.	2015/04/10/4f7011d2-02f1-4e2e-832e-2a6ede0661b6.	2015-04-10 06:57:09.730574	2015-04-10 06:57:09.730574	手机
13	39	2015/04/10/4fb3f7ba-0fb6-4cf6-b709-e688ebdf359d.	2015/04/10/fe0f89f6-d74b-4f49-a80f-e97e11e17ca4.	2015-04-10 06:59:09.830339	2015-04-10 06:59:09.830339	好时
16	46	2015/04/18/576ae234-e713-49e8-96c0-3c7f1172beff.	2015/04/18/a4650487-2daf-4630-ad55-d4a23ecb49e2.	2015-04-18 07:52:13.586685	2015-04-18 07:52:13.586685	
17	47	2015/04/18/777eda2e-863e-4c43-936c-1f7bff352b71.	2015/04/18/fa690a0e-0beb-4f6b-bec2-2882accc2bd2.	2015-04-18 08:01:45.536979	2015-04-18 08:01:45.536979	
\.


--
-- Name: dynamic_films_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('dynamic_films_id_seq', 22, true);


--
-- Data for Name: dynamic_images; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY dynamic_images (id, dynamic_id, image, created_at, updated_at, width, height, tag) FROM stdin;
2	10	2015/03/31/c41b2bbb-7e83-46ed-b587-5033fe9d88fb.jpg	2015-03-31 06:17:18.547224	2015-03-31 06:17:18.547224	200	133	{}
3	11	2015/03/31/b79de99a-3e79-4a54-97d7-4c05087e8531.jpg	2015-03-31 06:19:30.700241	2015-03-31 06:19:30.700241	200	133	{}
4	16	2015/04/08/3e5070ef-8d14-48e8-ad76-c57b59c062c9.jpeg	2015-04-08 03:54:21.541975	2015-04-08 03:54:21.541975	200	133	{}
5	16	2015/04/08/e763a95a-6f8b-4e77-a2c6-6f2b2482b7c5.jpeg	2015-04-08 03:54:21.657686	2015-04-08 03:54:21.657686	133	200	{}
6	23	2015/04/09/e4cd2858-d072-496f-a3fd-c79857e7f317.jpeg	2015-04-09 01:41:38.914579	2015-04-09 01:41:38.914579	200	133	{}
7	28	2015/04/09/cd2b6485-7b5d-429b-9e8f-f82801c1bd7c.jpeg	2015-04-09 03:14:57.527057	2015-04-09 03:14:57.527057	112	200	{}
9	30	2015/04/09/66252634-2751-44ef-ade5-34a9fd237a24.jpeg	2015-04-09 03:18:06.71581	2015-04-09 03:18:06.71581	112	200	{}
10	31	2015/04/09/e30bd4cc-2ef1-4242-a247-74029800b38d.	2015-04-09 03:18:45.045303	2015-04-09 03:18:45.045303	113	200	{}
11	34	2015/04/09/e5e547c3-1e84-4fd9-8235-a0d011b3a0c6.jpeg	2015-04-09 04:02:01.572383	2015-04-09 04:02:01.572383	200	133	{}
12	34	2015/04/09/6ecff685-674f-4f2e-b8b1-59b656832a59.jpeg	2015-04-09 04:02:01.745153	2015-04-09 04:02:01.745153	133	200	{}
13	35	2015/04/09/3ca0d225-beb4-470c-9539-66bc91e4e77c.jpeg	2015-04-09 04:17:41.376717	2015-04-09 04:17:41.376717	200	133	{}
14	36	2015/04/09/d1da991d-b1ce-46e4-9f23-49af1037b03e.jpeg	2015-04-09 04:19:23.117136	2015-04-09 04:19:23.117136	200	133	{}
15	40	2015/04/11/58d9e0af-f421-4fdb-834a-a9294aa4f034.jpeg	2015-04-11 04:11:42.233043	2015-04-11 04:11:42.233043	150	200	{}
16	40	2015/04/11/a8ca057b-c185-444f-971f-a762a0545306.jpeg	2015-04-11 04:11:42.358722	2015-04-11 04:11:42.358722	150	200	{}
17	40	2015/04/11/434767ff-d375-416e-a2cb-1fc0def772e9.jpeg	2015-04-11 04:11:42.517496	2015-04-11 04:11:42.517496	150	200	{}
18	40	2015/04/11/e98f948d-1484-4d52-afd3-58d18069e391.jpeg	2015-04-11 04:11:42.647455	2015-04-11 04:11:42.647455	150	200	{}
19	40	2015/04/11/227e4707-eee4-489b-a81f-04116cc43d16.jpeg	2015-04-11 04:11:42.780732	2015-04-11 04:11:42.780732	150	200	{}
20	40	2015/04/11/9f194bb0-52c8-4743-b9f1-14e8067d5c1c.jpeg	2015-04-11 04:11:42.920282	2015-04-11 04:11:42.920282	150	200	{}
21	42	2015/04/11/17f5de99-fb23-4515-b3bb-6d5209ae933d.jpeg	2015-04-11 08:19:15.97434	2015-04-11 08:19:15.97434	150	200	{}
22	42	2015/04/11/29bb7406-88b2-4b4f-894a-33707e82d3eb.jpeg	2015-04-11 08:19:16.15277	2015-04-11 08:19:16.15277	150	200	{}
23	42	2015/04/11/c87c24f0-e8b5-4298-919b-143f5fff945c.jpeg	2015-04-11 08:19:16.332687	2015-04-11 08:19:16.332687	150	200	{}
24	42	2015/04/11/34c6c994-6459-4150-becf-b72544aef398.jpeg	2015-04-11 08:19:16.493408	2015-04-11 08:19:16.493408	150	200	{}
25	42	2015/04/11/75fe9932-c390-4a9b-bef7-a0c5f4027fdc.jpeg	2015-04-11 08:19:16.679676	2015-04-11 08:19:16.679676	150	200	{}
26	42	2015/04/11/34a4c43a-3a06-409e-9625-403a6707ea3b.jpeg	2015-04-11 08:19:16.84434	2015-04-11 08:19:16.84434	150	200	{}
37	64	2015/09/19/ea9b32a7-9989-4696-8890-3fc1a4f1f675.jpg	2015-09-19 07:37:18.222332	2015-09-19 07:37:18.222332	300	437	{}
38	64	2015/09/19/4cd02cd6-42ed-41d7-9910-298a1bf1fe2e.jpg	2015-09-19 07:37:18.245707	2015-09-19 07:37:18.245707	300	200	{}
39	64	2015/09/19/0a1af0e9-21d6-4433-8cc5-f0935d21d245.jpg	2015-09-19 07:37:18.24751	2015-09-19 07:37:18.24751	300	300	{}
40	65	2015/09/23/c8983de4-17f6-4ae2-acc6-08d9426bb2de.jpg	2015-09-23 10:58:02.058598	2015-09-23 10:58:02.058598	300	437	{}
41	65	2015/09/23/4ce72cb4-0256-444f-b4ef-124030fe39ab.jpg	2015-09-23 10:58:02.061511	2015-09-23 10:58:02.061511	300	200	{}
42	65	2015/09/23/04371f26-2032-4b65-9be4-df9cbfa835c4.jpg	2015-09-23 10:58:02.063935	2015-09-23 10:58:02.063935	300	300	{}
43	65	2015/09/23/5baba5be-3228-4106-9eb4-6ebbc335124e.jpg	2015-09-23 10:58:02.066161	2015-09-23 10:58:02.066161	300	200	{}
44	66	2015/09/23/161b4dca-62f7-47c1-bfd5-c3c40ac08438.jpg	2015-09-23 11:28:20.027641	2015-09-23 11:28:20.027641	300	437	{}
45	66	2015/09/23/6f0607fc-42b4-4efb-a27e-85e44392b28c.jpg	2015-09-23 11:28:20.029758	2015-09-23 11:28:20.029758	300	200	{}
46	66	2015/09/23/650ca354-36d2-4eaa-bcf3-5aee4b80d5c0.jpg	2015-09-23 11:28:20.031717	2015-09-23 11:28:20.031717	300	300	{}
47	66	2015/09/23/96155743-fd92-4c8d-b952-c82c011c08e7.jpg	2015-09-23 11:28:20.03361	2015-09-23 11:28:20.03361	300	200	{}
48	66	2015/09/23/02c92f03-f7d4-4435-8a68-8a33062be9bc.jpeg	2015-09-23 11:28:20.035655	2015-09-23 11:28:20.035655	300	400	{}
49	66	2015/09/23/c77dc124-8e2d-42fb-957c-b66f87fccbbf.jpg	2015-09-23 11:28:20.038172	2015-09-23 11:28:20.038172	300	450	{}
50	67	2015/09/23/b863e768-4fd0-4238-aee0-957d008294e1.jpeg	2015-09-23 11:28:28.227486	2015-09-23 11:28:28.227486	300	400	{}
51	67	2015/09/23/e323fc82-b10a-43f1-bce1-3037863a2823.jpg	2015-09-23 11:28:28.230155	2015-09-23 11:28:28.230155	300	450	{}
52	67	2015/09/23/16b9eb0b-eab8-47d1-a14a-42639dde6a4c.jpg	2015-09-23 11:28:28.232289	2015-09-23 11:28:28.232289	300	450	{}
53	67	2015/09/23/b2ff688d-0331-40e3-8b1d-6f2086b3d502.jpg	2015-09-23 11:28:28.234088	2015-09-23 11:28:28.234088	300	450	{}
54	67	2015/09/23/3a6fd673-460e-4470-9202-d0bc7d850954.jpg	2015-09-23 11:28:28.235788	2015-09-23 11:28:28.235788	300	200	{}
55	67	2015/09/23/cee4898f-a071-4228-95ca-ac60b9372875.jpg	2015-09-23 11:28:28.237766	2015-09-23 11:28:28.237766	300	450	{}
56	69	2015/10/17/9df6a9df-8670-4f56-a236-56bdd5e4ba06.jpg	2015-10-17 09:46:37.218269	2015-10-17 09:46:37.218269	300	450	{}
57	70	2015/10/17/f242858d-e342-4ee5-ac5a-d631f2e5073b.jpg	2015-10-17 11:09:56.585865	2015-10-17 11:09:56.585865	300	200	{}
58	70	2015/10/17/84534dce-ef54-413e-9937-f117ac09313d.jpg	2015-10-17 11:09:56.588819	2015-10-17 11:09:56.588819	300	450	{}
59	70	2015/10/17/183700b5-845c-4477-bf8b-dddb6a5ff8aa.jpg	2015-10-17 11:09:56.591005	2015-10-17 11:09:56.591005	300	450	{}
60	70	2015/10/17/1d708923-df1a-4e9a-9083-997895c222ea.jpg	2015-10-17 11:09:56.593128	2015-10-17 11:09:56.593128	300	450	{}
61	70	2015/10/17/4a7e3377-bec5-4da1-b17a-b4c4e98df75b.jpg	2015-10-17 11:09:56.595191	2015-10-17 11:09:56.595191	300	450	{}
62	70	2015/10/17/bb4963f5-25e2-492c-80bf-49f9a64b7a89.jpg	2015-10-17 11:09:56.597383	2015-10-17 11:09:56.597383	300	452	{}
63	71	2015/10/19/dfa3f8f1-49dc-4bc6-806e-15879b1419fe.jpg	2015-10-19 05:15:41.159222	2015-10-19 05:15:41.159222	300	437	{}
64	71	2015/10/19/e160375e-96f3-4b2b-84c5-0f49929d56cc.jpg	2015-10-19 05:15:41.161424	2015-10-19 05:15:41.161424	300	200	{}
65	72	2015/10/21/698a0d63-e72d-48f9-bc8b-28d531169643.jpg	2015-10-21 07:33:51.492128	2015-10-21 07:33:51.492128	300	300	{}
66	73	2015/10/21/2c879dfc-1ac5-4d6a-81c7-ad09c7a8d51a.jpg	2015-10-21 07:34:41.767176	2015-10-21 07:34:41.767176	300	300	{}
67	75	2015/10/22/0dc426d8-5aeb-4c65-9a78-6ea7fc18eb75.jpg	2015-10-22 09:07:12.31764	2015-10-22 09:07:12.31764	300	200	{}
68	76	2015/10/22/b747183b-4739-41a7-8719-0957f60c5fc1.jpg	2015-10-22 09:07:27.191886	2015-10-22 09:07:27.191886	300	450	{}
\.


--
-- Name: dynamic_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('dynamic_images_id_seq', 68, true);


--
-- Data for Name: dynamics; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY dynamics (id, user_id, content, created_at, updated_at, top) FROM stdin;
6	4	接口上传健身视频	2015-03-31 01:58:20.089434	2015-03-31 01:58:20.089434	1
10	4	\N	2015-03-31 06:17:18.502502	2015-03-31 06:17:18.502502	0
11	4	命令测试发布动态(带图)	2015-03-31 06:19:30.660728	2015-03-31 06:19:30.660728	0
14	4	命令测试发布动态(带视频)	2015-03-31 06:23:17.743724	2015-03-31 06:23:17.743724	0
15	15	\N	2015-04-08 03:26:56.595003	2015-04-08 03:26:56.595003	0
16	15	\N	2015-04-08 03:54:21.395534	2015-04-08 03:54:21.395534	0
17	15	\N	2015-04-08 07:20:10.082884	2015-04-08 07:20:10.082884	0
18	15	\N	2015-04-08 07:35:18.909915	2015-04-08 07:35:18.909915	0
19	15	\N	2015-04-08 07:39:20.783546	2015-04-08 07:39:20.783546	0
20	15	\N	2015-04-08 07:48:03.503294	2015-04-08 07:48:03.503294	0
21	15	哦破XP	2015-04-08 10:38:05.572277	2015-04-08 10:38:05.572277	0
23	15	\N	2015-04-09 01:41:38.783254	2015-04-09 01:41:38.783254	0
25	15	987654321	2015-04-09 02:46:45.126118	2015-04-09 02:46:45.126118	1
26	15	XP魔头也	2015-04-09 03:02:23.125712	2015-04-09 03:02:23.125712	0
27	15	在我佛我我我佛学院	2015-04-09 03:12:36.85108	2015-04-09 03:12:36.85108	0
28	15	yyyuuuuijjdhjdjejdjjdj	2015-04-09 03:14:57.383079	2015-04-09 03:14:57.383079	0
30	15	1369979767944	2015-04-09 03:18:06.579428	2015-04-09 03:18:06.579428	0
31	15	哦么哦喔喔哦哦	2015-04-09 03:18:44.781084	2015-04-09 03:18:44.781084	0
32	15	形容头绪需要	2015-04-09 03:29:34.388435	2015-04-09 03:29:34.388435	0
33	15	111111111	2015-04-09 03:33:12.367807	2015-04-09 03:33:12.367807	0
34	15	qqeqweqweqweq	2015-04-09 04:02:01.398067	2015-04-09 04:02:01.398067	0
35	15	asdasdas	2015-04-09 04:17:41.195832	2015-04-09 04:17:41.195832	0
36	15	qweqeqweqeq	2015-04-09 04:19:22.909424	2015-04-09 04:19:22.909424	0
37	15	你是时间	2015-04-09 07:34:31.972433	2015-04-09 07:34:31.972433	1
38	15	想念基督教	2015-04-10 06:57:09.594137	2015-04-10 06:57:09.594137	1
39	38	想不到好	2015-04-10 06:59:09.712083	2015-04-10 06:59:09.712083	1
40	38	小宝贝先后下降手不释卷时间那些爸爸的话你不咸不淡吧并行不悖的吧	2015-04-11 04:11:42.093925	2015-04-11 04:11:42.093925	0
41	38	我们	2015-04-11 08:13:23.246373	2015-04-11 08:13:23.246373	0
42	38		2015-04-11 08:19:15.809472	2015-04-11 08:19:15.809472	0
43	17	aaa	2015-04-11 08:19:52.843782	2015-04-11 08:19:52.843782	0
45	48	嗨哦嫉妒了特 u 杜拉推荐了	2015-04-17 08:17:04.186893	2015-04-17 08:17:04.186893	0
46	48		2015-04-18 07:52:13.452622	2015-04-18 07:52:13.452622	1
47	48		2015-04-18 08:01:45.324518	2015-04-18 08:01:45.324518	1
48	48	头配肉哦	2015-04-18 10:05:08.23264	2015-04-18 10:05:08.23264	0
63	51	测试发布图片动态	2015-09-19 07:34:07.098096	2015-09-19 07:34:07.098096	0
64	51	测试发布图片动态1	2015-09-19 07:37:18.220857	2015-09-19 07:37:18.220857	0
65	51	111	2015-09-23 10:58:02.0563	2015-09-23 10:58:02.0563	0
66	51	111	2015-09-23 11:28:20.025994	2015-09-23 11:28:20.025994	0
67	51	111	2015-09-23 11:28:28.225956	2015-09-23 11:28:28.225956	0
68	\N	\N	2015-10-16 07:58:34.611066	2015-10-16 07:58:34.611066	0
69	55		2015-10-17 09:46:37.215314	2015-10-17 09:46:37.215314	0
70	55		2015-10-17 11:09:56.583711	2015-10-17 11:09:56.583711	0
71	81	111	2015-10-19 05:15:41.157737	2015-10-19 05:15:41.157737	0
72	81	111	2015-10-21 07:33:51.490031	2015-10-21 07:33:51.490031	0
73	81	111	2015-10-21 07:34:41.764477	2015-10-21 07:34:41.764477	0
75	81	11	2015-10-22 09:07:12.315435	2015-10-22 09:07:12.315435	0
76	81		2015-10-22 09:07:27.189668	2015-10-22 09:07:27.189668	0
\.


--
-- Name: dynamics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('dynamics_id_seq', 76, true);


--
-- Data for Name: expiries; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY expiries (id, coach_id, date, created_at, updated_at) FROM stdin;
\.


--
-- Name: expiries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('expiries_id_seq', 1, false);


--
-- Data for Name: feedbacks; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY feedbacks (id, user_id, content, contact, created_at, updated_at) FROM stdin;
1	45	weqw	eqweqw	2015-04-17 06:40:00.997764	2015-04-17 06:40:00.997764
2	45	dasd	dasda	2015-04-17 06:42:45.17245	2015-04-17 06:42:45.17245
3	48	曲目xyu	tutsrjlkk	2015-04-18 03:11:10.107555	2015-04-18 03:11:10.107555
4	48	你来咯女	偶我哦	2015-04-18 03:11:30.663886	2015-04-18 03:11:30.663886
5	45	fsfsdf	fsdfsdf	2015-04-18 03:14:20.125847	2015-04-18 03:14:20.125847
6	45	asdasddas	fsdsfdsfsdfds	2015-04-18 03:15:02.363877	2015-04-18 03:15:02.363877
7	45	fwfwefwe	rwerewrwe	2015-04-18 03:15:24.572859	2015-04-18 03:15:24.572859
8	45	dasdasd	dsadasdsa	2015-04-18 03:17:28.472879	2015-04-18 03:17:28.472879
9	45	sdasdsa	dsadsadas	2015-04-18 03:18:30.962108	2015-04-18 03:18:30.962108
10	45	dasdsadas	dasdasdas	2015-04-18 03:20:05.222041	2015-04-18 03:20:05.222041
11	45	adasdas	dadas	2015-04-18 03:20:34.82291	2015-04-18 03:20:34.82291
12	45	dasdasdas	adasdsadsa	2015-04-18 03:21:37.941907	2015-04-18 03:21:37.941907
13	45	eqewq	wqeqwewqe	2015-04-18 03:22:03.082637	2015-04-18 03:22:03.082637
14	45	dsadasdas	dasdasdasda	2015-04-18 03:22:26.942591	2015-04-18 03:22:26.942591
15	45	fsfsdfsd	fdsfsdf	2015-04-18 03:24:01.652859	2015-04-18 03:24:01.652859
16	45	dasdas	dasdasfafsd	2015-04-18 03:24:45.812795	2015-04-18 03:24:45.812795
17	48	再见咯啊困了	太久了	2015-04-18 03:27:37.057065	2015-04-18 03:27:37.057065
18	48	gleijj	teutefu	2015-04-18 03:28:45.733293	2015-04-18 03:28:45.733293
\.


--
-- Name: feedbacks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('feedbacks_id_seq', 18, true);


--
-- Data for Name: follows; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY follows (id, service_id, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: follows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('follows_id_seq', 1, false);


--
-- Data for Name: galleries; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY galleries (id, user_id, tag) FROM stdin;
8	\N	食之有胃
\.


--
-- Name: galleries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('galleries_id_seq', 8, true);


--
-- Data for Name: gallery_images; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY gallery_images (id, gallery_id, image, caption) FROM stdin;
9	8	2015/08/05/e4f3432d-fe70-4e8c-8c29-4127c2090c99.jpg	111
\.


--
-- Name: gallery_images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('gallery_images_id_seq', 9, true);


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY group_members (id, group_id, user_id, tag, tag_name, created_at, updated_at) FROM stdin;
\.


--
-- Name: group_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('group_members_id_seq', 30, true);


--
-- Data for Name: group_photos; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY group_photos (id, group_id, photo, created_at, updated_at) FROM stdin;
1	22	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:42.422539	2015-04-10 03:30:42.422539
2	23	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:43.594824	2015-04-10 03:30:43.594824
3	24	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:44.356701	2015-04-10 03:30:44.356701
4	25	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:44.706834	2015-04-10 03:30:44.706834
5	26	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:45.08285	2015-04-10 03:30:45.08285
6	27	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:45.448572	2015-04-10 03:30:45.448572
7	28	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:45.817564	2015-04-10 03:30:45.817564
8	29	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:46.208868	2015-04-10 03:30:46.208868
9	30	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:30:46.573355	2015-04-10 03:30:46.573355
10	31	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:31:08.879988	2015-04-10 03:31:08.879988
11	32	(\n    "<UIImage: 0x7fe7f3c89ea0>"\n)	2015-04-10 03:31:09.23036	2015-04-10 03:31:09.23036
12	33	#<ActionDispatch::Http::UploadedFile:0x007f4ebc268bf0>	2015-04-10 03:42:47.762717	2015-04-10 03:42:47.762717
13	33	#<ActionDispatch::Http::UploadedFile:0x007f4ebc2685d8>	2015-04-10 03:42:47.770677	2015-04-10 03:42:47.770677
14	34	2015/04/10/2f7c6838-d766-49ab-b88d-7bb119c04b24.jpeg	2015-04-10 03:46:29.883053	2015-04-10 03:46:29.883053
15	34	2015/04/10/2ad9ea57-0f21-4335-99e6-868a59dd671e.jpeg	2015-04-10 03:46:30.009175	2015-04-10 03:46:30.009175
62	51	2015/04/16/6cbb51c8-dcc4-40e5-87a6-1bc9341b0e20.jpeg	2015-04-16 01:49:17.860366	2015-04-16 01:49:17.860366
63	51	2015/04/16/292e87f1-5581-417e-bd95-fac1d0cd1d78.jpeg	2015-04-16 01:49:18.024717	2015-04-16 01:49:18.024717
64	51	2015/04/16/645a653e-7ae2-4b2c-878f-77a87707eca8.jpeg	2015-04-16 01:49:18.153893	2015-04-16 01:49:18.153893
65	51	2015/04/16/1dfb06f9-095f-4148-ab05-762dd82500a5.jpeg	2015-04-16 01:49:18.252045	2015-04-16 01:49:18.252045
66	51	2015/04/16/ab1a51e3-9e81-4082-b9b3-e5be34a9777f.jpeg	2015-04-16 01:49:18.362031	2015-04-16 01:49:18.362031
67	52	2015/04/16/8040c088-2162-40a8-b2c9-1a75840ddf94.jpeg	2015-04-16 02:19:52.091957	2015-04-16 02:19:52.091957
68	52	2015/04/16/ecd21a00-ea31-4602-9c0e-d116b26f143b.jpeg	2015-04-16 02:19:52.164786	2015-04-16 02:19:52.164786
69	52	2015/04/16/26b08f1b-f7a4-4eaa-82e3-b7120d3238ed.jpeg	2015-04-16 02:19:52.276444	2015-04-16 02:19:52.276444
70	52	2015/04/16/2cf2d736-bfe3-4f2f-b9f7-a710bf20b144.jpeg	2015-04-16 02:19:52.414264	2015-04-16 02:19:52.414264
71	52	2015/04/16/0cedb8d9-ae28-4bfb-9085-25499fb4c372.jpeg	2015-04-16 02:19:52.521752	2015-04-16 02:19:52.521752
72	53	2015/04/16/a48c3714-7ca3-4326-aa1c-d7682f0f799f.jpeg	2015-04-16 07:47:12.374529	2015-04-16 07:47:12.374529
73	53	2015/04/16/7bd7ba70-3418-4571-8891-e5b6ce25aaa5.jpeg	2015-04-16 07:47:12.452216	2015-04-16 07:47:12.452216
74	53	2015/04/16/e93972cb-ef5b-4d27-a99e-67c46c388672.jpeg	2015-04-16 07:47:12.566191	2015-04-16 07:47:12.566191
75	54	2015/04/18/07adda8d-e07a-4644-b6a2-5d5e365785dc.jpeg	2015-04-18 07:41:32.221087	2015-04-18 07:41:32.221087
76	54	2015/04/18/b84d6106-8460-4322-a3c4-9a65219bcb04.jpeg	2015-04-18 07:41:32.322736	2015-04-18 07:41:32.322736
77	57	2015/04/18/61e5ed74-2e01-40a1-897b-3df6c613fe6f.jpeg	2015-04-18 07:48:49.111735	2015-04-18 07:48:49.111735
78	57	2015/04/18/7fae92f2-6bce-4768-af47-67a40f965b66.jpeg	2015-04-18 07:48:49.240509	2015-04-18 07:48:49.240509
79	57	2015/04/18/bada7146-c26d-4d6b-9e12-69447776ac1f.jpeg	2015-04-18 07:48:49.375674	2015-04-18 07:48:49.375674
80	60	2015/04/20/a7ad11f2-870d-46f1-add9-eeb3b978194d.jpeg	2015-04-20 04:18:10.415569	2015-04-20 04:18:10.415569
\.


--
-- Name: group_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('group_photos_id_seq', 80, true);


--
-- Data for Name: group_places; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY group_places (id, group_id, lonlat, created_at, updated_at) FROM stdin;
1	1	0101000020E61000000000000000805EC00000000000A05140	2015-04-01 03:09:41.441621	2015-04-01 03:09:41.441621
2	53	\N	2015-04-16 07:47:12.259725	2015-04-16 07:47:12.259725
3	54	\N	2015-04-18 07:41:32.108703	2015-04-18 07:41:32.108703
4	57	\N	2015-04-18 07:48:48.97652	2015-04-18 07:48:48.97652
5	60	\N	2015-04-20 04:18:10.315508	2015-04-20 04:18:10.315508
6	63	\N	2015-05-03 06:58:39.285503	2015-05-03 06:58:39.285503
\.


--
-- Name: group_places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('group_places_id_seq', 6, true);


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY groups (id, name, interests, intro, created_at, updated_at, easemob_id, owner) FROM stdin;
51	我的群	0,0,0	群简介	2015-04-16 01:49:17.237755	2015-04-16 01:49:17.237755	1429148868325533	10030
52	群组222	0,0,0	群组简介12323	2015-04-16 02:19:51.77386	2015-04-16 02:42:35.254261	1429150702561848	10030
53	QQ登陆群	0,0,0	67979863561976465989398	2015-04-16 07:47:11.981617	2015-04-16 07:47:11.981617	142917034363159	10015
54	构筑	0,0,0	想念的那些	2015-04-18 07:41:31.742482	2015-04-18 07:41:31.742482	1429342804504327	10045
57	新群	0,0,0	我们的	2015-04-18 07:48:48.768354	2015-04-18 07:48:48.768354	1429343241403077	10037
60	途径就是	1,2,3,4,5,6,7,8	很天涯旅	2015-04-20 04:18:10.068661	2015-04-20 04:18:10.068661	1429503404110812	57
63	啊啊	1,2,3,4	啊发放	2015-05-03 06:58:38.992319	2015-05-03 07:32:09.364279	1430636243996522	10020
\.


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('groups_id_seq', 63, true);


--
-- Data for Name: hit_reports; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY hit_reports (id, report_date, point, number, created_at, updated_at) FROM stdin;
\.


--
-- Name: hit_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('hit_reports_id_seq', 1, false);


--
-- Data for Name: hits; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY hits (id, date, device, point, number) FROM stdin;
1	\N	\N	1	2
2	\N	\N	2	2
3	\N	\N	3	2
4	\N	\N	1	3
5	\N	\N	1	4
6	\N	\N	2	4
\.


--
-- Name: hits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('hits_id_seq', 6, true);


--
-- Data for Name: lessons; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY lessons (id, order_id, coach_id, user_id, course_id, available, used, exp, order_no, contact_name, contact_phone, sku) FROM stdin;
\.


--
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('lessons_id_seq', 1, false);


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY likes (id, like_type, user_id, liked_id, created_at, updated_at) FROM stdin;
1	1	4	1	2015-03-31 08:15:16.959296	2015-03-31 08:15:16.959296
5	1	30	35	2015-04-14 08:43:01.006575	2015-04-14 08:43:01.006575
6	1	30	42	2015-04-14 08:44:24.482763	2015-04-14 08:44:24.482763
7	1	30	41	2015-04-14 08:45:42.205974	2015-04-14 08:45:42.205974
8	1	30	40	2015-04-14 08:46:05.893401	2015-04-14 08:46:05.893401
9	1	30	39	2015-04-14 08:46:08.958491	2015-04-14 08:46:08.958491
10	1	30	38	2015-04-14 08:46:12.829444	2015-04-14 08:46:12.829444
11	1	30	37	2015-04-14 08:46:16.264119	2015-04-14 08:46:16.264119
12	1	30	36	2015-04-14 08:46:19.322855	2015-04-14 08:46:19.322855
13	1	30	43	2015-04-15 03:29:18.756783	2015-04-15 03:29:18.756783
14	1	38	42	2015-04-17 00:50:16.03986	2015-04-17 00:50:16.03986
15	1	38	41	2015-04-17 00:50:17.823062	2015-04-17 00:50:17.823062
16	1	38	42	2015-04-17 00:50:27.69317	2015-04-17 00:50:27.69317
17	1	38	42	2015-04-17 00:50:29.312462	2015-04-17 00:50:29.312462
18	1	38	42	2015-04-17 00:50:30.871194	2015-04-17 00:50:30.871194
19	1	38	38	2015-04-17 00:54:29.622908	2015-04-17 00:54:29.622908
20	1	38	38	2015-04-17 00:54:30.812304	2015-04-17 00:54:30.812304
21	1	38	38	2015-04-17 00:54:37.513815	2015-04-17 00:54:37.513815
22	1	38	37	2015-04-17 00:55:53.992984	2015-04-17 00:55:53.992984
23	1	38	36	2015-04-17 00:55:55.771901	2015-04-17 00:55:55.771901
24	1	48	45	2015-04-17 09:36:12.977834	2015-04-17 09:36:12.977834
25	1	48	45	2015-04-17 09:36:14.643326	2015-04-17 09:36:14.643326
26	1	48	45	2015-04-17 09:36:15.814106	2015-04-17 09:36:15.814106
27	1	48	45	2015-04-17 09:36:16.553535	2015-04-17 09:36:16.553535
28	1	48	45	2015-04-17 09:36:17.141155	2015-04-17 09:36:17.141155
29	1	48	45	2015-04-17 09:36:17.833135	2015-04-17 09:36:17.833135
30	1	48	45	2015-04-17 09:36:18.392545	2015-04-17 09:36:18.392545
31	1	48	45	2015-04-17 09:36:19.246789	2015-04-17 09:36:19.246789
32	1	48	45	2015-04-17 09:36:19.8307	2015-04-17 09:36:19.8307
33	1	48	45	2015-04-17 09:36:20.553671	2015-04-17 09:36:20.553671
34	1	48	45	2015-04-17 09:36:21.30248	2015-04-17 09:36:21.30248
35	1	48	45	2015-04-17 09:36:22.042832	2015-04-17 09:36:22.042832
36	1	48	45	2015-04-17 09:36:22.791275	2015-04-17 09:36:22.791275
37	1	48	45	2015-04-17 09:36:23.455576	2015-04-17 09:36:23.455576
38	1	48	45	2015-04-17 09:36:24.053677	2015-04-17 09:36:24.053677
39	1	48	45	2015-04-17 09:36:24.833336	2015-04-17 09:36:24.833336
40	1	48	45	2015-04-17 09:36:25.403013	2015-04-17 09:36:25.403013
41	1	48	45	2015-04-17 09:36:26.194429	2015-04-17 09:36:26.194429
42	1	48	45	2015-04-17 09:36:26.872782	2015-04-17 09:36:26.872782
43	1	45	11	2015-04-18 02:46:38.513494	2015-04-18 02:46:38.513494
44	1	45	11	2015-04-18 02:46:39.608575	2015-04-18 02:46:39.608575
45	1	45	11	2015-04-18 02:46:40.512954	2015-04-18 02:46:40.512954
46	1	45	11	2015-04-18 02:46:41.420621	2015-04-18 02:46:41.420621
47	1	45	11	2015-04-18 02:46:43.171493	2015-04-18 02:46:43.171493
48	1	45	14	2015-04-18 02:46:46.110548	2015-04-18 02:46:46.110548
49	1	45	14	2015-04-18 02:46:47.138114	2015-04-18 02:46:47.138114
50	1	48	45	2015-04-18 03:10:10.88612	2015-04-18 03:10:10.88612
51	1	48	45	2015-04-18 03:10:11.563686	2015-04-18 03:10:11.563686
52	1	48	45	2015-04-18 03:10:12.262472	2015-04-18 03:10:12.262472
53	1	48	45	2015-04-18 03:10:13.152012	2015-04-18 03:10:13.152012
54	1	48	45	2015-04-18 03:10:13.947221	2015-04-18 03:10:13.947221
55	1	48	45	2015-04-18 03:10:14.662092	2015-04-18 03:10:14.662092
56	1	48	45	2015-04-18 03:10:15.683286	2015-04-18 03:10:15.683286
57	1	48	45	2015-04-18 03:10:16.21108	2015-04-18 03:10:16.21108
58	1	48	45	2015-04-18 03:10:16.862399	2015-04-18 03:10:16.862399
59	1	48	45	2015-04-18 03:10:17.911971	2015-04-18 03:10:17.911971
60	1	48	45	2015-04-18 03:10:18.601803	2015-04-18 03:10:18.601803
61	1	48	45	2015-04-18 03:10:19.258737	2015-04-18 03:10:19.258737
62	1	48	45	2015-04-18 03:10:20.613423	2015-04-18 03:10:20.613423
63	1	48	45	2015-04-18 03:10:21.252874	2015-04-18 03:10:21.252874
64	1	48	45	2015-04-18 03:10:22.132503	2015-04-18 03:10:22.132503
65	1	48	45	2015-04-18 03:10:22.971909	2015-04-18 03:10:22.971909
66	1	48	45	2015-04-18 03:10:23.540976	2015-04-18 03:10:23.540976
67	1	48	45	2015-04-18 03:10:24.331843	2015-04-18 03:10:24.331843
68	1	48	45	2015-04-18 03:10:25.022585	2015-04-18 03:10:25.022585
69	1	48	45	2015-04-18 03:10:25.667656	2015-04-18 03:10:25.667656
70	1	48	45	2015-04-18 03:10:26.469061	2015-04-18 03:10:26.469061
71	1	48	45	2015-04-18 03:10:27.182816	2015-04-18 03:10:27.182816
72	1	48	45	2015-04-18 03:10:28.263878	2015-04-18 03:10:28.263878
73	1	48	45	2015-04-18 03:10:30.603649	2015-04-18 03:10:30.603649
74	1	48	45	2015-04-18 03:10:31.382275	2015-04-18 03:10:31.382275
75	1	48	45	2015-04-18 03:10:32.062271	2015-04-18 03:10:32.062271
76	1	48	45	2015-04-18 03:10:32.653188	2015-04-18 03:10:32.653188
77	1	48	45	2015-04-18 03:10:33.442058	2015-04-18 03:10:33.442058
78	1	48	45	2015-04-18 03:10:34.282583	2015-04-18 03:10:34.282583
79	1	48	45	2015-04-18 03:10:35.022243	2015-04-18 03:10:35.022243
80	1	48	45	2015-04-18 03:10:35.703378	2015-04-18 03:10:35.703378
81	1	48	45	2015-04-18 03:10:36.341116	2015-04-18 03:10:36.341116
82	1	48	45	2015-04-18 03:10:36.982353	2015-04-18 03:10:36.982353
83	1	48	45	2015-04-18 03:10:37.89279	2015-04-18 03:10:37.89279
84	1	48	45	2015-04-18 03:10:38.652541	2015-04-18 03:10:38.652541
85	1	48	45	2015-04-18 03:10:39.411861	2015-04-18 03:10:39.411861
86	1	48	45	2015-04-18 03:10:40.092051	2015-04-18 03:10:40.092051
87	1	48	45	2015-04-18 03:10:40.893014	2015-04-18 03:10:40.893014
88	1	48	45	2015-04-18 03:10:41.642918	2015-04-18 03:10:41.642918
89	1	48	45	2015-04-18 03:10:42.432738	2015-04-18 03:10:42.432738
90	1	48	47	2015-04-18 09:31:37.949928	2015-04-18 09:31:37.949928
91	1	48	47	2015-04-18 09:31:39.361383	2015-04-18 09:31:39.361383
92	1	48	47	2015-04-18 09:31:40.072045	2015-04-18 09:31:40.072045
93	1	48	47	2015-04-18 09:31:41.042527	2015-04-18 09:31:41.042527
94	1	48	47	2015-04-18 09:31:42.491916	2015-04-18 09:31:42.491916
95	1	48	47	2015-04-18 09:31:43.448492	2015-04-18 09:31:43.448492
96	1	48	45	2015-04-18 09:36:32.251107	2015-04-18 09:36:32.251107
97	1	48	45	2015-04-18 09:36:33.001285	2015-04-18 09:36:33.001285
98	1	48	47	2015-04-18 09:42:11.741204	2015-04-18 09:42:11.741204
99	1	48	1	2015-04-18 10:01:18.873263	2015-04-18 10:01:18.873263
100	1	48	2	2015-04-18 10:01:20.811821	2015-04-18 10:01:20.811821
101	1	48	3	2015-04-18 10:01:28.242944	2015-04-18 10:01:28.242944
102	1	48	4	2015-04-18 10:01:39.643963	2015-04-18 10:01:39.643963
103	1	48	47	2015-04-18 10:02:42.092447	2015-04-18 10:02:42.092447
104	1	48	47	2015-04-18 10:03:30.823705	2015-04-18 10:03:30.823705
105	1	48	1	2015-04-18 10:04:04.571483	2015-04-18 10:04:04.571483
106	1	48	1	2015-04-18 10:06:31.612077	2015-04-18 10:06:31.612077
107	1	48	47	2015-04-18 10:39:10.89335	2015-04-18 10:39:10.89335
\.


--
-- Name: likes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('likes_id_seq', 108, true);


--
-- Data for Name: mass_message_groups; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY mass_message_groups (id, service_id, name, user_id, created_at, updated_at) FROM stdin;
\.


--
-- Name: mass_message_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('mass_message_groups_id_seq', 9, true);


--
-- Data for Name: mass_messages; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY mass_messages (id, service_id, user_id, content, created_at, updated_at) FROM stdin;
\.


--
-- Name: mass_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('mass_messages_id_seq', 1, false);


--
-- Data for Name: news; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY news (id, title, cover, created_at, updated_at, content, cover_width, cover_height, tag) FROM stdin;
11	专访金像影后赵薇：替黄渤遗憾 只有50%拿奖胜算	2015/04/20/f08bc923-7fcf-4fc3-807a-1b27ef3c1316.jpg	2015-04-20 06:26:46.184796	2015-04-20 06:37:34.010513	<p><strong class="cRed">&nbsp;&nbsp;&nbsp; <span style="color:#FF0000;">网易娱乐4月20日报道（文/cjl 图、视频/哨兵）</span></strong>&nbsp;金马失意，金像得意，赵薇去年曾 凭《亲爱的》提名金马最佳女主角，最后输给了陈湘琪，今年她终于凭借《亲爱的》力压汤唯、阿Sa等对手，夺得影后桂冠。采访前，大家都不停的恭喜赵薇，她 连换衣服的时间都没有，匆匆忙忙的接受了网易娱乐的专访，在镜头面前，这位影后完全不矫揉造作，&ldquo;我要不要换衣，哈哈。&rdquo;</p>\r\n\r\n<p><img src="http://img2.cache.netease.com/ent/2015/4/20/201504200142141d5cd_550.jpg" /></p>\r\n\r\n<p>&nbsp;&nbsp; 之前就曾4次提名金像奖的她表示，自己完全没有拿奖的野心，甚至在念到自己名字的时候还走神了。在后台赵薇信誓旦旦称要和刘青云合作，&ldquo;就互相给对方捧捧场，不要当真。&rdquo;</p>\r\n\r\n<p>演员的一次至高巅峰没有让她漂浮，赵薇说，既要把演员做好了，也要把导演本身做好了才行。不过她也透露自己不会指导《致青春2》等青春片了，接下 来，赵薇将从《亲爱的》中的母亲角色变成《港囧》里的疯婆子。谈及朋友，赵薇表示自己会替黄渤感到遗憾，&ldquo;我一直觉得他不断拍下去会横扫各个奖项的，他的 青春路还很长，会不断拿奖到老。&rdquo;</p>\r\n	690	1035	
12	 孙红雷：小时候暗恋学习好的女生 曾跟踪对方	2015/04/20/bd0378a7-70ca-4290-a97e-59ca93cce743.jpg	2015-04-20 06:40:11.490258	2015-04-20 06:40:11.490258	<p>&nbsp;&nbsp;&nbsp; <strong>中新网4月20日电 </strong>孙红雷今天在北京宣传新片时，大方回忆青春时期的往事，他透露自己曾暗恋成绩好的女生，并跟踪对方。</p>\r\n\r\n<p>&nbsp;&nbsp;&nbsp; 19日，电影《少年班》在北京举行发布会，导演肖洋携主演孙红雷、周冬雨、董子健、王栎鑫、柳希龙、李佳奇出席捧场。</p>\r\n\r\n<p>&nbsp;&nbsp; <img src="http://img6.cache.netease.com/ent/2015/4/20/2015042002391854f76.jpg" /></p>\r\n\r\n<p>&nbsp;&nbsp; 孙红雷此次在《少年班》里饰演一位外表儒雅、城府颇深的少年班导师。他透露这次拍摄非常有幸福感，也存有私心，&ldquo;我小时候淘气，但学习好，内心是好学生的粉丝，会暗恋形象不是特别好，但学习特别好的女生，还暗自跟踪过&rdquo;。</p>\r\n	690	1034	
\.


--
-- Name: news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('news_id_seq', 12, true);


--
-- Data for Name: online_reports; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY online_reports (id, report_date, avg, period, number, created_at, updated_at) FROM stdin;
\.


--
-- Name: online_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('online_reports_id_seq', 1, false);


--
-- Data for Name: onlines; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY onlines (id, date, device, open, close) FROM stdin;
1	\N	1	2015-06-05 10:00:00	2015-06-05 10:10:00
2	\N	1	2015-06-05 10:15:00	2015-06-05 10:30:00
\.


--
-- Name: onlines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('onlines_id_seq', 2, true);


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY order_items (id, order_id, course_id, name, type, cover, price, amount, created_at, updated_at, during, sku) FROM stdin;
\.


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('order_items_id_seq', 1, false);


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY orders (id, user_id, coach_id, no, coupons, bean, contact_name, contact_phone, pay_type, total, pay_amount, status, created_at, updated_at, service_id) FROM stdin;
\.


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('orders_id_seq', 1, false);


--
-- Data for Name: overviews; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY overviews (id, report_date, activation, register, activity) FROM stdin;
1	2015-07-06	0	0	0
2	2015-07-07	0	0	0
\.


--
-- Name: overviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('overviews_id_seq', 2, true);


--
-- Data for Name: photos; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY photos (id, user_id, photo, created_at, updated_at, loc) FROM stdin;
89	105	2015/05/14/a2e89408-8b26-4478-8e92-6d1ae5078113.jpeg	2015-05-14 10:16:19.247141	2015-05-14 10:16:19.247141	\N
90	103	2015/05/18/5afb60c5-85aa-47ec-8534-60dd9ef05c99.jpg	2015-05-18 07:26:20.241176	2015-05-18 07:26:20.241176	\N
93	103	2015/05/18/73f6d533-5dc2-47e4-8ef3-d870b0f5a503.jpg	2015-05-18 08:06:16.962582	2015-05-18 08:06:16.962582	\N
94	110	2015/07/14/2b55b474-2f92-4dd9-9913-2f51b5e7d192.jpg	2015-07-14 08:27:26.675331	2015-07-14 08:27:26.675331	\N
98	81	2015/10/19/e33d47f5-9366-4447-8579-fc8688c59010.jpeg	2015-10-12 14:46:53.216631	2015-10-19 10:42:00.787411	3
101	81	2015/10/19/579f3556-4763-4390-8b0a-d1623d56eda1.jpg	2015-10-13 10:37:59.190542	2015-10-19 10:42:00.928832	0
102	81	2015/10/19/10290474-559c-40c2-a805-07c9f33e644e.jpg	2015-10-19 10:42:01.076445	2015-10-19 10:42:01.076445	\N
103	81	2015/10/19/a058e570-995f-4d33-9b1c-0af127db4447.jpg	2015-10-19 10:42:01.318225	2015-10-19 10:42:01.318225	\N
95	81	2015/10/19/eac31fbc-33a0-4746-b3c8-7bbe49d71e6d.jpeg	2015-10-12 14:46:52.535419	2015-10-19 10:42:14.094267	0
96	81	2015/10/19/cef944b0-a11b-4bc1-bcdb-dac16ac0ffb4.jpg	2015-10-12 14:46:52.837219	2015-10-19 10:42:45.933669	1
104	81	2015/10/19/bfa56dc9-35c4-4888-a369-439cd46e70b5.jpg	2015-10-19 10:51:38.23777	2015-10-19 10:51:38.23777	\N
97	81	2015/10/19/f0a3e609-07d3-46f0-b7c7-d8f0542aa3da.jpg	2015-10-12 14:46:53.044279	2015-10-19 10:56:33.401821	2
\.


--
-- Name: photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('photos_id_seq', 104, true);


--
-- Data for Name: places; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY places (id, user_id, lonlat, created_at, updated_at) FROM stdin;
14	47	0101000020E6100000A07FD5AA215A5E4006C43EEEFD333F40	2015-04-18 03:56:23.015258	2015-04-18 03:56:23.015258
4	4	0101000020E61000000000000000805EC00000000000805140	2015-03-31 10:11:49.156014	2015-04-01 01:36:53.424365
11	46	0101000020E6100000A44EF580215A5E40A174F08D00343F40	2015-04-15 08:05:34.903884	2015-04-18 09:15:21.882546
10	45	0101000020E610000000000000000000000000000000000000	2015-04-15 06:56:15.622193	2015-04-18 07:23:50.634238
9	27	0101000020E610000076E272BC029A5EC0DD0A613596E44240	2015-04-15 06:11:06.644671	2015-04-15 09:01:43.988162
7	38	0101000020E6100000FECEE2C6205A5E40CEC70C8102343F40	2015-04-15 04:05:07.030604	2015-04-20 03:26:47.488764
12	37	0101000020E6100000DEA53ABA215A5E40232B0965FF333F40	2015-04-15 10:29:36.802443	2015-04-17 05:24:05.931729
5	15	0101000020E6100000822E5642255A5E40329DA0E1FE333F40	2015-04-09 03:20:26.357772	2015-04-18 03:33:25.123669
8	30	0101000020E610000000000000000000000000000000000000	2015-04-15 04:05:07.193498	2015-04-16 07:38:24.812723
13	48	0101000020E610000055B1EFBE215A5E403FB2903300343F40	2015-04-16 06:45:08.253291	2015-04-20 05:10:44.590943
6	17	0101000020E610000060B2AA16DE5A5E407019BEFF1A353F40	2015-04-09 06:03:38.558768	2015-04-23 04:03:23.876257
16	81	0101000020E610000060B2AA16DE5A5E407019BEFF1A353F40	2015-04-25 09:52:09.010468	2015-04-25 09:52:09.010468
19	51	0101000020E6100000499765F8D7565E403BDC54A17C383F40	2015-09-24 11:55:03.71168	2015-09-24 11:55:03.71168
20	55	0101000020E6100000499765F8D7565E403BDC54A17C383F40	2015-09-24 11:57:25.383752	2015-09-24 11:57:25.383752
\.


--
-- Name: places_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('places_id_seq', 20, true);


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY profiles (id, user_id, signature, name, avatar, gender, identity, birthday, address, target, skill, often_stadium, interests, mobile, service, hobby, province, city) FROM stdin;
29	29		1232		1	0	2000-04-09							{}	{}	\N	\N
90	96	这家伙很懒,什么也没留下	啦啦啦啦	2015/04/16/dc82e3a8-01c9-43ee-83cf-a2b6b6c144ba.jpg	1	1	2014-09-01	上海市长宁区中山西路933号1206	什么和什么	我我我我	他他他他啊			{}	{}	\N	\N
91	97	这家伙很懒,什么也没留下	我什么和我	2015/04/16/db7cd676-7429-46ba-b6e4-c481a69b4492.jpg	1	1	2015-04-16	上海市宝山区真华路926弄3号1116	2131231	什么和什么	问问我我			{}	{}	\N	\N
18	18		The memory of counterclockwise	2015/04/07/94c9e64e-7580-42f3-8f98-4229da8f89e0.jpeg	0	0	2000-04-07							{}	{}	\N	\N
19	19		HobaoKing	2015/04/07/40b05cb9-51d1-49d9-90cf-cd45106ed89e.jpeg	0	0	2000-04-07							{}	{}	\N	\N
55	56		0o。泡泡♂	2015/04/09/6f68e2c0-c14c-42f3-8e4c-5eebc6c66f3a.jpeg	2	2	2000-04-09						\N	{}	{}	\N	\N
79	80	这家伙很懒,什么也没留下	我是一个服务号	2015/04/13/5d3bc9e5-c376-40cd-9536-7898d82b0aa6.jpg	2	2	2000-04-13							{}	{}	\N	\N
58	59		0		1	1	2000-04-09						11111111112	{}	{}	\N	\N
76	77		\N		1	1	2000-04-13						\N	{}	{}	\N	\N
75	76		私教	2015/04/11/a18b91c7-54d3-4f13-81cf-4cec3831f2dc.jpg	1	1	2000-04-11						\N	{}	{}	\N	\N
20	20		ds		1	0	2000-04-07							{}	{}	\N	\N
21	21		wda		1	0	2000-04-07							{}	{}	\N	\N
22	22		adas		1	0	2000-04-07							{}	{}	\N	\N
23	23		qd		1	0	2000-04-07							{}	{}	\N	\N
24	24		uhiuh		1	0	2000-04-08							{}	{}	\N	\N
25	25		\N		1	0	2000-04-08							{}	{}	\N	\N
26	26		15026637572		1	0	2000-04-08							{}	{}	\N	\N
31	31		111		1	0	2000-04-09							{}	{}	\N	\N
32	32		123123		1	0	2000-04-09							{}	{}	\N	\N
38	39		wode 		1	0	2000-04-09						15617656313	{}	{}	\N	\N
39	40		111		1	0	2000-04-09						1213133113	{}	{}	\N	\N
40	41		1234567		1	0	2000-04-09						1234567	{}	{}	\N	\N
41	42		1234		1	0	2000-04-09						1234	{}	{}	\N	\N
42	43		123		1	0	2000-04-09						123	{}	{}	\N	\N
46	47		4		1	0	2000-04-09						4	{}	{}	\N	\N
48	49		11		1	0	2000-04-09						11	{}	{}	\N	\N
49	50		22		1	0	2000-04-09						22	{}	{}	\N	\N
51	52		121		1	0	2000-04-09						121	{}	{}	\N	\N
52	53		21		1	0	2000-04-09						21	{}	{}	\N	\N
53	54		13		1	0	2000-04-09						13	{}	{}	\N	\N
56	57		磊		1	0	2000-04-09						13585753578	{}	{}	\N	\N
57	58		1		1	1	2000-04-09						11111111111	{}	{}	\N	\N
17	17	这家伙很懒,什么也没留下	\N	2015/04/16/9d62e673-5adb-47ec-bfdb-3b525e3dbd61.jpg	\N	0	2000-04-23							{}	{}	\N	\N
98	104	这家伙很懒,什么也没留下	上海Love小北	2015/04/18/cb00ba78-ef6b-43d1-8439-0f24619d88bb.gif	0	1	2000-04-18							{}	{}	\N	\N
78	79		\N		1	1	2000-04-13						\N	{}	{}	\N	\N
85	86	这家伙很懒,什么也没留下	glczg	2015/04/15/82a63efd-f941-445a-92c0-1491f9e629fa.jpeg	0	1	2000-04-15							{}	{}	\N	\N
81	82	这家伙很懒,什么也没留下	这家伙很懒,什么也没留下	2015/04/13/fc7cd7e2-bd74-4c48-aa81-42ff1702bd28.jpg	0	1	2000-04-27	上海市虹桥路	健身	游泳	虹桥	1,2,3		{}	{1,2,3}	\N	\N
30	30		你猜	2015/04/15/6db91589-488f-4b91-ba24-7910965eb64e.jpg	0	0	\N					2,5,8		{}	{2,5,8}	\N	\N
45	46	dasdsads	3	2015/04/15/c6338bf0-2339-49fe-adae-2c6f49720bb5.jpg	1	0	\N	北京通州				4,5,6	3	{}	{4,5,6}	\N	\N
94	100	这家伙很懒,什么也没留下	111	2015/04/18/ac9b31ba-c391-48cf-916d-24fa5ad4935e.jpg	\N	1	1955-05-05	das	sadas	aaa		["", "1", "2", "3"]		{}	{0,0,0,0}	\N	\N
15	15		 心动丶已漠然	2015/04/07/7cacf03d-a7d0-4bb8-ad07-98e36bf8c5ee.jpeg	0	0	1314-04-17					7,9,10,11		{}	{7,9,10,11}	\N	\N
89	95	这家伙很懒,什么也没留下	大帝	2015/04/16/8ff4f0f0-52b0-43a3-9afe-2cd6caf8e377.jpg	1	1	1988-12-28	中山虹桥	伤害	拳击	中山虹桥	拳击		{}	{0}	\N	\N
96	102	这家伙很懒,什么也没留下	我哦我我我我我我啊	2015/04/18/64955969-6afa-4370-9144-c6e7411c6c8c.jpg	0	1	2015-04-17	上海市中山西路933号1206 上海市中山西路933号1206	上海市中山西路933号1206 上海市中山西路933号1206	上海市中山西路933号1206 上海市中山西路933号1206		["", "1", "2", "3", "4", "6", "22", "23", "24", "25", "26"]		{}	{0,0,0,0,0,0,0,0,0,0,0}	\N	\N
97	103	这家伙很懒,什么也没留下	我和我的是啊 123232		1	1	2015-04-14	就是不熬噶苏你啊啊啊的速度速度就 是不熬噶苏你啊啊啊的速度速度	就是不熬噶苏你啊啊啊的速度速度就 是不熬噶苏你啊啊啊的速度速度	就是不熬噶苏你啊啊啊的速度速度就 是不熬噶苏你啊啊啊的速度速度		["", "1", "2", "3"]		{}	{0,0,0,0}	\N	\N
36	37		123		0	0	\N					1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20	18768895205	{}	{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}	\N	\N
37	38		曹123		1	0	\N					2,4,5,6,8,9,10,11	13391078500	{}	{2,4,5,6,8,9,10,11}	\N	\N
47	48	涂涂卡罗距离距离	5	2015/04/17/cc0c837b-a2be-42a8-915f-cb72ee61ec0b.jpg	0	0	\N	四川宜宾	yanj	我纠结了	推进经济	1,2,3,4,5,6,7,8	5	{}	{1,2,3,4,5,6,7,8}	\N	\N
84	85	这家伙很懒,什么也没留下	丘比特→_→之贱	2015/04/15/686feb09-de17-4b69-84d4-5fffeb508209.jpeg	0	1	2000-04-15							{}	{}	\N	\N
83	84	这家伙很懒,什么也没留下	该用户名有效	2015/04/15/47e63a43-4d2b-4642-a8bd-0962c2e5edd6.gif	0	1	2000-04-15							{}	{}	\N	\N
99	105	这家伙很懒,什么也没留下	小予不舍	2015/04/21/b2bc8822-6e80-4e93-b5bd-2b99780e2fae.jpeg	0	1	2000-06-05							{}	{}	\N	\N
4	4	这家伙很懒,什么也没留下	\N		\N	0	\N						18516691251	\N	{}	\N	\N
77	78		阿飞		1	1	2000-04-13						\N	{}	{}	\N	\N
44	45	qewqeqwewqwewq	2	2015/04/15/dfc0c4a3-e14d-48ce-8096-5d5d9cadf78b.jpg	0	0	\N	上海普陀	我是刘德华	jianzhenshanchang	jianshenfang	3,4,5,6,7	2	{}	{3,4,5,6,7}	\N	\N
95	101	这家伙很懒,什么也没留下	什么和什么啊啊啊	2015/04/18/26767fe5-7e84-4573-9055-f7502a44db04.jpg	0	1	2015-04-15	什么和什么啊啊啊 什么和什么啊啊啊	什么和什么啊啊啊 什么和什么啊啊啊	什么和什么啊啊啊 什么和什么啊啊啊		["", "1", "5", "16", "17", "18", "19", "20", "21", "22"]		{}	{0,0,0,0,0,0,0,0,0,0}	\N	\N
102	108	这家伙很懒,什么也没留下	鸟叔1	2015/06/23/35f2667c-408f-43dd-945c-25414c44309d.jpg	0	1	1986-06-23					1,2,3		{}	{1,2,3}	\N	\N
104	110	签名有效	鸟叔2	2015/06/29/cb7dc659-c5d9-477c-a846-9497a89b83c1.jpg	1	1	\N	上海市长宁区中山西路933号	没有目标	无领域	不常去	1,2		{}	{1,2}	\N	\N
27	27	sadasdsandkskdskla	习惯某个人	2015/04/08/95247266-8956-41e4-9446-ffb73c7d9a81.jpeg	0	1	1986-04-15	北京通州	dasdasda	dasdasdsa	dasdsada	dsadasda		{}	{0}	\N	\N
126	141	11	1	2015/09/18/947d2438-08fa-4ae4-9c21-acc15900bb11.jpg	0	1	1999-03-20	1111	1	1	1	10,18		{}	{10,18}	\N	\N
127	142	111	111	2015/09/23/60ac6b2a-ac1e-45eb-abc1-60211e85ef40.jpg	0	1	1999-03-20	上海市宝山区	111	111	111	1,2,3		{}	{1,2,3}	\N	\N
132	51	没有什么要介绍到	我是官方服务号		0	0	1999-03-20	上海市市辖区长宁区金钟路988号				1,3,4,5,7,9,10,12,16,17	13916518973	{}	{1,3,4,5,7,9,10,12,16,17}	\N	\N
80	81	简单介绍一下	美型线上店	2015/10/12/b95fdb23-6149-472d-9d9e-9998adf1941a.jpg	\N	2	2000-04-25	虹桥银城大厦				2,3,4,5	021-65555555	{1,2,3,4}	{2,3,4,5}	上海市	长宁区
128	143	111	111	2015/09/24/535f5787-fe5d-40f6-8b45-39afd42cce16.jpg	0	0	1999-03-20	安徽省合肥市蜀山区	111	111	11	5,6		{}	{5,6}	\N	\N
135	145				0	0	1999-03-20							{}	{}	\N	\N
136	146	111	111	2015/10/12/8db32d57-547c-4de8-b8b3-f5b704475947.jpg	0	1	1999-03-03							{}	{1,2,3,5}	\N	\N
137	147		11111		0	1	1999-03-20							{}	{1,2}	\N	\N
133	55	111	我是官方服务号	2015/10/17/c5ddf63f-4965-49b4-aac7-f56349ce7125.jpg	0	2	1999-03-20	111				1,3,4,5,7,9,10,12,16,17	111	{1,2,3,4}	{1,2,3,4,5}	北京市	东城区
\.


--
-- Name: profiles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('profiles_id_seq', 139, true);


--
-- Data for Name: recommends; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY recommends (id, type, recommended_id, recommended_tip, created_at, updated_at) FROM stdin;
5	1	142	1	2015-10-27 03:34:18.998028	2015-10-27 03:34:18.998028
\.


--
-- Name: recommends_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('recommends_id_seq', 5, true);


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY reports (id, report_type, content, user_id, report_id, created_at, updated_at) FROM stdin;
1	\N	\N	45	\N	2015-04-17 07:23:13.2505	2015-04-17 07:23:13.2505
2	\N	\N	45	\N	2015-04-17 07:23:14.625559	2015-04-17 07:23:14.625559
3	\N	\N	45	\N	2015-04-17 07:23:14.661996	2015-04-17 07:23:14.661996
4	3	骚扰信息	45	\N	2015-04-17 07:34:06.213534	2015-04-17 07:34:06.213534
5	3	骚扰信息	45	\N	2015-04-17 07:36:47.372905	2015-04-17 07:36:47.372905
6	3	骚扰信息	45	52	2015-04-17 07:51:05.113	2015-04-17 07:51:05.113
7	3	骚扰信息	45	52	2015-04-17 07:56:23.922986	2015-04-17 07:56:23.922986
8	3	骚扰信息	45	52	2015-04-17 07:59:50.883069	2015-04-17 07:59:50.883069
9	3	盗用他人资料	48	52	2015-04-17 08:07:10.25872	2015-04-17 08:07:10.25872
10	3	色情相关	48	52	2015-04-17 08:07:41.476844	2015-04-17 08:07:41.476844
11	3	盗用他人资料	48	52	2015-04-17 08:07:45.824257	2015-04-17 08:07:45.824257
12	3	骚扰信息	48	52	2015-04-17 08:07:49.49602	2015-04-17 08:07:49.49602
13	3	资料不当	48	52	2015-04-17 08:07:53.694319	2015-04-17 08:07:53.694319
14	3	垃圾广告	48	52	2015-04-17 08:07:57.468974	2015-04-17 08:07:57.468974
15	3	色情相关	48	52	2015-04-17 08:08:40.262231	2015-04-17 08:08:40.262231
16	3	盗用他人资料	48	52	2015-04-17 08:08:44.036845	2015-04-17 08:08:44.036845
17	3	色情相关	48	52	2015-04-17 08:10:13.814023	2015-04-17 08:10:13.814023
18	3	盗用他人资料	48	52	2015-04-17 08:10:17.617658	2015-04-17 08:10:17.617658
19	3	垃圾广告	48	52	2015-04-17 08:10:23.53008	2015-04-17 08:10:23.53008
20	2	色情相关	48	45	2015-04-17 08:28:03.092685	2015-04-17 08:28:03.092685
21	2	骚扰信息	48	45	2015-04-17 08:28:22.380027	2015-04-17 08:28:22.380027
22	2	盗用他人资料	48	45	2015-04-17 08:28:26.113895	2015-04-17 08:28:26.113895
23	2	垃圾广告	48	45	2015-04-17 08:28:29.321295	2015-04-17 08:28:29.321295
24	2	色情相关	48	45	2015-04-17 08:30:33.659893	2015-04-17 08:30:33.659893
25	1	色情相关	48	10037	2015-04-17 09:09:49.700875	2015-04-17 09:09:49.700875
26	1	盗用他人资料	48	10037	2015-04-17 09:09:52.663697	2015-04-17 09:09:52.663697
27	1	骚扰信息	48	10037	2015-04-17 09:09:55.989364	2015-04-17 09:09:55.989364
28	2	骚扰信息	45	10	2015-04-18 02:43:45.815025	2015-04-18 02:43:45.815025
29	2	资料不当	45	10	2015-04-18 02:43:49.091905	2015-04-18 02:43:49.091905
30	2	盗用他人资料	45	10	2015-04-18 02:43:52.553162	2015-04-18 02:43:52.553162
31	1	色情相关	48	10037	2015-04-18 05:20:30.151195	2015-04-18 05:20:30.151195
32	3	垃圾广告	48	52	2015-04-20 01:43:04.857934	2015-04-20 01:43:04.857934
\.


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('reports_id_seq', 32, true);


--
-- Data for Name: retentions; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY retentions (id, report_date, register, day_one, day_three, day_seven) FROM stdin;
\.


--
-- Name: retentions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('retentions_id_seq', 1, false);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY schema_migrations (version) FROM stdin;
20141120104644
20141120104646
20150319103312
20150319103553
20150319105802
20150319112053
20150320065743
20150320070425
20150320070510
20150320074359
20150320103634
20150323020644
20150623093558
20150625081830
20150323035446
20150323090215
20150323090349
20150323090826
20150325073810
20150811123711
20150326052424
20150626015421
20150627061529
20150629021326
20150702094545
20150326070010
20150327080743
20150703042925
20150329094511
20150706020608
20150401023405
20150401041744
20150706073556
20150401042438
20150404133842
20150521015221
20150407091139
20150706075828
20150814073327
20150526081936
20150526083246
20150903102006
20150417055405
20150417055441
20150708024737
20150708091747
20150420061156
20150421062118
20150423080205
20150503082253
20150917120741
20150917124636
20150925130149
20150713021842
20150526092125
20150526093159
20150527025159
20150602083616
20150602084145
20150505024030
20150514030058
20150603063445
20151012021411
20151026041638
20150708091911
20150710024300
20150710024310
20150714021010
20150716023831
20150716024819
20150717021529
20150723034009
20150724120900
20150615090338
20150616074322
20150605080932
20150605080941
20150608081116
20150610024814
20150610093101
20150610093208
20150611021609
20150612031900
20150613071733
20150617055907
20150619084656
20150725021916
20150727025429
20150728080402
20150728081137
20150728081151
20150730074931
20150803060531
\.


--
-- Data for Name: service_courses; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY service_courses (id, name, type, style, during, proposal, exp, intro, special, service, limit_start, limit_end, status, image, created_at, updated_at) FROM stdin;
21	1234	1	1v1	30	1	183	1	1	{}	\N	\N	1	{2015/08/08/4c46dc5b60822dca2e6aa98b657a4f91.jpg,2015/08/08/550eec0d0e072f000c77bdee9e06e393.jpg,2015/08/08/0134bb645639af493b03d4be60e06da0.jpg}	2015-08-08 10:01:20.236642	2015-08-08 10:01:29.936687
22	111	1	1 v2	30	1	183	1	1	{}	2015-08-13 03:00:00	2015-08-27 10:00:00	0	{2015/08/13/3b59d70b3636bb89409ff0a315194986.jpg,2015/08/13/c3f4a2f92175a97292c259ec1aab919d.jpg,2015/08/13/4963e529adf8c0a2bbf5368c2c667db5.jpg,2015/08/13/4a0edbec29e6c00a9a6305991c6403a6.jpg}	2015-08-13 11:35:47.639845	2015-08-13 11:35:47.639845
5	1	1	1v1	30	1	183	1	1	{2}	\N	\N	0	{2015/08/07/4c242d484de0fd4c9b1f752b280e11c1.jpg,2015/08/07/62d9883417e8397e9861361a0ba06ea1.jpg,2015/08/07/36381650542885f6eb643f4c9c5846b9.jpg}	2015-08-07 08:48:19.499749	2015-08-07 08:48:19.499749
6	1	1	1v30	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/07d415f1-3bb8-4a33-9127-72b71d58f583.jpg,2015/08/08/3aae1a05-cef2-41f7-a3ad-1da9ca9b4f74.jpg,2015/08/08/9ec9f2ec-18fd-4727-bfcb-a08b5da58fd2.jpg}	2015-08-08 06:09:31.26687	2015-08-08 06:09:31.26687
7	1	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/d7015b29fe08daa5486c1965dfbd5f0a.jpg,2015/08/08/e0ba18bddd8413193b8d6d11971dc46a.jpg,2015/08/08/8435d2737822337ec98556198dc9045e.jpg}	2015-08-08 06:31:02.395041	2015-08-08 06:31:02.395041
8	111	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/4c2a4b17e165df6a83edf8535c9a0ff8.jpg,2015/08/08/ea345c5126f6add9c6cd658a917ba538.jpg,2015/08/08/6343fe6d0106e35a12a37921ec80d283.jpg}	2015-08-08 06:34:25.894611	2015-08-08 06:34:25.894611
9	111	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/be5c8a16-2c73-4513-b6f1-9abd25c4cf1b.jpg,2015/08/08/be5c8a16-2c73-4513-b6f1-9abd25c4cf1b.jpg,2015/08/08/be5c8a16-2c73-4513-b6f1-9abd25c4cf1b.jpg}	2015-08-08 06:39:48.613868	2015-08-08 06:39:48.613868
11	11	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/96df7ede-8853-45c4-a8f4-9265b0326f2b.jpg,2015/08/08/5b8b9ed1-3f04-4850-82a5-f432f6bf1e89.jpg,2015/08/08/f7aa632e-6a7a-444d-9b77-dd5286f427e4.jpg}	2015-08-08 06:47:32.666452	2015-08-08 06:47:32.666452
12	111	1	1v1	30	1	183	11	11	{}	\N	\N	0	{2015/08/08/73100ffa-e27a-4962-b454-082785de3e6c.jpg,2015/08/08/27065745-e7e9-4424-9c2e-f26ad009d64c.jpg,2015/08/08/f955b4fd-6ee4-4c75-8280-3079828abcc4.jpg}	2015-08-08 06:51:37.278511	2015-08-08 06:51:37.278511
13	111	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/7d2b8e75-1944-4961-8843-cf716d911836.jpg,2015/08/08/5822f01d-9fe2-4568-9667-fb6495db63f8.jpg,2015/08/08/997c307e-443a-4fec-83bc-72c4788045c4.jpg}	2015-08-08 06:53:57.276472	2015-08-08 06:53:57.276472
14	111	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/28136f22-f9ba-444d-b9c7-3ca4ab809f3a.jpg,2015/08/08/28136f22-f9ba-444d-b9c7-3ca4ab809f3a.jpg,2015/08/08/28136f22-f9ba-444d-b9c7-3ca4ab809f3a.jpg}	2015-08-08 07:08:12.042991	2015-08-08 07:08:12.042991
15	11	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/18889922-a9ba-446e-a1ca-3b2feb47de9d.jpg,2015/08/08/18889922-a9ba-446e-a1ca-3b2feb47de9d.jpg,2015/08/08/18889922-a9ba-446e-a1ca-3b2feb47de9d.jpg}	2015-08-08 07:10:21.98507	2015-08-08 07:10:21.98507
16	11	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/1f8c3a6d19521f0ae346bf7ede109384.jpg,2015/08/08/fc3ddd8534449e0e0cd7b1b493ab4add.jpg,2015/08/08/beac0c0fd7e9072271409eabeba6bd13.jpg}	2015-08-08 07:17:06.312973	2015-08-08 07:17:06.312973
17	111	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/1f8c3a6d19521f0ae346bf7ede109384.jpg,2015/08/08/fc3ddd8534449e0e0cd7b1b493ab4add.jpg,2015/08/08/beac0c0fd7e9072271409eabeba6bd13.jpg}	2015-08-08 07:20:29.532336	2015-08-08 07:20:29.532336
18	1	1	1v1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/d106161033da24ceb07a0103fd837433.jpg,2015/08/08/bb319a954eef4a99b72e60f9b295f123.jpg,2015/08/08/a7c9585703d275249f30a088cebba0ad.jpg}	2015-08-08 07:21:59.419805	2015-08-08 07:21:59.419805
19	123	1	1	30	1	183	1	1	{}	\N	\N	0	{2015/08/08/13913|247|360.jpg,2015/08/08/19265|541|360.jpg,2015/08/08/6230|200|200.jpg}	2015-08-08 09:47:04.266808	2015-08-08 09:47:04.266808
20	123	1	1	30	1	183	1	1	{}	\N	\N	1	{2015/08/08/4c46dc5b60822dca2e6aa98b657a4f91.jpg,2015/08/08/550eec0d0e072f000c77bdee9e06e393.jpg,2015/08/08/0134bb645639af493b03d4be60e06da0.jpg}	2015-08-08 09:50:34.373943	2015-08-08 09:50:46.532846
\.


--
-- Name: service_courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('service_courses_id_seq', 22, true);


--
-- Data for Name: service_members; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY service_members (id, service_id, coach_id, created_at, updated_at) FROM stdin;
20	17	76	2015-04-11 09:00:06.500075	2015-04-11 09:00:06.500075
21	81	82	2015-04-13 10:18:43.108358	2015-04-13 10:18:43.108358
27	17	95	2015-04-16 05:56:37.535283	2015-04-16 05:56:37.535283
28	17	96	2015-04-16 06:31:43.797678	2015-04-16 06:31:43.797678
32	17	97	2015-04-16 06:34:17.554269	2015-04-16 06:34:17.554269
35	17	101	2015-04-18 04:02:24.801413	2015-04-18 04:02:24.801413
36	17	102	2015-04-18 04:03:20.261912	2015-04-18 04:03:20.261912
37	17	103	2015-04-18 04:04:13.90265	2015-04-18 04:04:13.90265
44	51	78	2015-06-02 04:30:57.477701	2015-06-02 04:30:57.477701
45	56	77	2015-06-02 04:31:32.148454	2015-06-02 04:31:32.148454
48	89	108	2015-06-23 06:58:33.381528	2015-06-23 06:58:33.381528
50	89	110	2015-06-29 06:13:07.732576	2015-06-29 06:13:07.732576
51	51	27	2015-09-15 12:42:34.729699	2015-09-15 12:42:34.729699
52	51	139	2015-09-18 02:22:08.43298	2015-09-18 02:22:08.43298
53	51	140	2015-09-18 02:25:44.127612	2015-09-18 02:25:44.127612
54	51	141	2015-09-18 02:26:56.206231	2015-09-18 02:26:56.206231
55	51	142	2015-09-23 10:57:05.554565	2015-09-23 10:57:05.554565
58	55	146	2015-10-12 10:21:29.577979	2015-10-12 10:21:29.577979
59	55	147	2015-10-12 11:15:47.654709	2015-10-12 11:15:47.654709
\.


--
-- Name: service_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('service_members_id_seq', 59, true);


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY settings (id, user_id, stealth) FROM stdin;
\.


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('settings_id_seq', 1, false);


--
-- Data for Name: showtimes; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY showtimes (id, user_id, title, cover, film, intro, created_at, updated_at) FROM stdin;
\.


--
-- Name: showtimes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('showtimes_id_seq', 1, false);


--
-- Data for Name: skus; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY skus (id, sku, course_id, course_type, course_name, course_cover, course_guarantee, seller, seller_id, market_price, selling_price, store, "limit", address, coordinate, comments_count, orders_count, concerns_count, created_at, updated_at, status, service_id) FROM stdin;
5	SC-000005-000051	5	1	1	\N	\N	我是官方服务号	51	11.0	11.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-07 08:48:19.551598	2015-08-07 08:48:19.551598	0	\N
6	SC-000006-000051	6	1	1	\N	\N	我是官方服务号	51	1.0	1.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 06:09:31.319409	2015-08-08 06:09:31.319409	0	\N
7	SC-000007-000051	7	1	1	\N	\N	我是官方服务号	51	11.0	1.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 06:31:02.439503	2015-08-08 06:31:02.439503	0	\N
8	SC-000008-000051	8	1	111	\N	\N	我是官方服务号	51	11.0	1.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 06:34:25.899662	2015-08-08 06:34:25.899662	0	\N
9	SC-000009-000051	9	1	111	\N	\N	我是官方服务号	51	11.0	11.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 06:39:48.654747	2015-08-08 06:39:48.654747	0	\N
11	SC-000011-000051	11	1	11	\N	\N	我是官方服务号	51	1.0	1.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 06:47:32.718415	2015-08-08 06:47:32.718415	0	\N
12	SC-000012-000051	12	1	111	\N	\N	我是官方服务号	51	11.0	11.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 06:51:37.317095	2015-08-08 06:51:37.317095	0	\N
13	SC-000013-000051	13	1	111	\N	\N	我是官方服务号	51	1.0	1.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 06:53:57.313712	2015-08-08 06:53:57.313712	0	\N
14	SC-000014-000051	14	1	111	\N	\N	我是官方服务号	51	11.0	11.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 07:08:12.075046	2015-08-08 07:08:12.075046	0	\N
15	SC-000015-000051	15	1	11	\N	\N	我是官方服务号	51	11.0	1.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 07:10:22.020865	2015-08-08 07:10:22.020865	0	\N
16	SC-000016-000051	16	1	11	\N	\N	我是官方服务号	51	11.0	11.0	11	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 07:17:06.356661	2015-08-08 07:17:06.356661	0	\N
17	SC-000017-000051	17	1	111	\N	\N	我是官方服务号	51	11.0	11.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 07:20:29.566502	2015-08-08 07:20:29.566502	0	\N
18	SC-000018-000051	18	1	1	\N	\N	我是官方服务号	51	11.0	11.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 07:21:59.467723	2015-08-08 07:21:59.467723	0	\N
19	SC-000019-000051	19	1	123	\N	\N	我是官方服务号	51	11.0	11.0	11	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 09:47:04.310489	2015-08-08 09:47:04.310489	0	\N
20	SC-000020-000051	20	1	123	http://stage.e-mxing.com/images/photo/thumb_2015/08/08/4c46dc5b60822dca2e6aa98b657a4f91.jpg	\N	我是官方服务号	51	11.0	11.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 09:50:34.419039	2015-08-08 09:50:34.419039	1	\N
21	SC-000021-000051	21	1	1234	http://stage.e-mxing.com/images/photo/thumb_2015/08/08/4c46dc5b60822dca2e6aa98b657a4f91.jpg	\N	我是官方服务号	51	1.0	1.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-08 10:01:20.285678	2015-08-08 10:01:20.285678	1	\N
22	SC-000022-000051	22	1	111	http://stage.e-mxing.com/images/course/thumb_2015/08/13/3b59d70b3636bb89409ff0a315194986.jpg	\N	我是官方服务号	51	1.0	1.0	1	-1	上海市市辖区长宁区金钟路988号	0101000020E6100000499765F8D7565E403BDC54A17C383F40	0	0	0	2015-08-13 11:35:47.651563	2015-08-13 11:35:47.651563	0	\N
\.


--
-- Name: skus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('skus_id_seq', 22, true);


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: tracks; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY tracks (id, user_id, track_type, start, created_at, updated_at, name, intro, address, places, free_places, coach_id, during) FROM stdin;
6	17	3	2015-05-02 00:00:00	2015-04-11 08:13:14.916609	2015-04-11 08:13:14.916609	综合训练	综合训练1234	中山西路933号	50	10	\N	60
7	30	1	2015-04-18 14:27:06	2015-04-13 06:28:23.511895	2015-04-13 06:28:23.511895	剑术	\N	\N	\N	0	\N	60
8	30	1	2015-04-18 14:31:11	2015-04-13 06:32:27.009988	2015-04-13 06:32:27.009988	高尔夫	\N	\N	\N	0	\N	60
9	30	1	2015-04-18 17:00:05	2015-04-13 06:35:44.703656	2015-04-13 06:35:44.703656	剑术	\N	\N	\N	0	\N	60
10	30	1	2015-04-13 14:38:50	2015-04-13 06:40:33.162751	2015-04-13 06:40:33.162751	俯卧撑	\N	\N	\N	0	\N	60
11	30	1	2015-04-13 06:03:38	2015-04-13 07:04:55.925682	2015-04-13 07:04:55.925682	钓鱼	\N	\N	\N	0	\N	60
12	30	1	2015-04-13 06:12:31	2015-04-13 09:13:55.484549	2015-04-13 09:13:55.484549	剑术	\N	\N	\N	0	\N	60
13	30	1	2015-04-13 07:13:46	2015-04-13 09:15:04.706774	2015-04-13 09:15:04.706774	溜冰	\N	\N	\N	0	\N	60
14	45	1	2015-04-14 11:04:39	2015-04-14 03:05:50.46277	2015-04-14 03:05:50.46277	滑冰	\N	\N	\N	0	\N	60
15	45	1	2015-04-14 11:17:12	2015-04-14 03:18:23.155588	2015-04-14 03:18:23.155588	剑术	\N	\N	\N	0	\N	60
16	46	1	2015-03-28 09:53:03	2015-04-15 01:54:44.757862	2015-04-15 01:54:44.757862	保龄球	\N	\N	\N	0	\N	60
17	46	1	2015-04-15 09:53:36	2015-04-15 01:55:20.593575	2015-04-15 01:55:20.593575	单杠	\N	\N	\N	0	\N	60
18	46	1	2015-04-15 09:54:44	2015-04-15 01:56:25.814958	2015-04-15 01:56:25.814958	单杠	\N	\N	\N	0	\N	60
19	46	1	2015-04-15 11:15:04	2015-04-15 03:16:55.326307	2015-04-15 03:16:55.326307	单杠	大家好	上海	100	50	\N	60
20	45	1	2015-04-17 11:57:31	2015-04-15 04:00:57.156707	2015-04-15 04:00:57.156707	俯卧撑	大家好	上海	1	50	\N	60
21	45	1	2015-04-15 13:02:42	2015-04-15 05:04:17.372146	2015-04-15 05:04:17.372146	保龄球	大家好	上海	3	0	\N	60
22	45	1	2015-04-15 13:04:00	2015-04-15 05:06:37.743079	2015-04-15 05:06:37.743079	保龄球	大家好	上海	0	0	\N	60
23	45	1	2015-04-15 13:12:27	2015-04-15 05:14:06.781098	2015-04-15 05:14:06.781098	钓鱼	\N	\N	\N	0	\N	60
27	45	3	2015-04-16 10:34:00	2015-04-16 02:36:40.716562	2015-04-16 02:36:40.716562	ddas	大家好	上海	0	0	\N	60
28	45	3	2015-04-16 10:35:00	2015-04-16 02:36:57.302416	2015-04-16 02:36:57.302416	fdsfds	大家好	上海	1	0	\N	60
29	45	2	2015-04-16 10:36:00	2015-04-16 02:37:53.435351	2015-04-16 02:37:53.435351	ticao	大家好	上海	1	0	\N	60
31	45	3	2015-04-16 10:58:00	2015-04-16 03:00:03.551965	2015-04-16 03:00:03.551965	力量	\N	\N	\N	0	\N	60
30	17	1	2015-04-17 00:00:00	2015-04-16 02:56:30.955493	2015-04-16 03:30:46.364066	团操一个	介绍介绍姐姐打法放那份大幅发达发放 	中山虹桥	100	10	\N	60
32	38	3	2015-04-16 13:53:00	2015-04-16 05:55:28.900414	2015-04-16 05:55:28.900414	课程名称	 不能宁静	经济界	1	0	\N	13
33	38	10	2015-04-16 14:05:00	2015-04-16 06:08:18.475208	2015-04-16 06:08:18.475208	课程名称	想不到暖暖的你	上课地址	5	0	\N	0
34	38	6	2015-04-16 14:21:00	2015-04-16 06:23:25.504118	2015-04-16 06:23:25.504118	课程名称	那些大家	上课地址	0	0	\N	864
35	38	5	2015-04-17 14:02:00	2015-04-16 07:00:28.056658	2015-04-16 07:00:28.056658	课程名称	顶焦度计	上课地址	0	0	\N	118
38	48	2	2015-04-14 16:14:00	2015-04-17 08:15:50.19481	2015-04-17 08:15:50.19481	lvtu		hutu	0	0	\N	974
39	48	3	2015-04-17 16:14:00	2015-04-17 08:16:15.927604	2015-04-17 08:16:15.927604	痛苦		考虑他	4	0	\N	974
40	48	3	2015-04-18 11:28:00	2015-04-18 03:30:26.499333	2015-04-18 03:30:26.499333	巨头	世界纪录么哭了开口啦吃哦带路咯旅途咯喔莫突来看看被拒绝咯就如同分组里噶侧就开始咯哦	距咯哦	18	0	\N	0
41	48	6	2015-04-18 11:56:00	2015-04-18 03:58:21.073748	2015-04-18 03:58:21.073748	跳绳	\N	\N	\N	0	\N	11
42	48	4	2015-04-18 12:22:00	2015-04-18 04:23:46.904512	2015-04-18 04:23:46.904512	登山	\N	\N	\N	0	\N	0
43	48	6	2015-04-18 12:22:00	2015-04-18 04:24:20.313786	2015-04-18 04:24:20.313786	跳绳	\N	\N	\N	0	\N	0
44	46	5	2015-04-18 13:03:00	2015-04-18 05:08:04.095057	2015-04-18 05:08:04.095057	综合训练	\N	\N	\N	0	\N	0
45	38	2	2015-04-18 17:49:00	2015-04-18 09:51:11.683067	2015-04-18 09:51:11.683067	体操	\N	\N	\N	0	\N	4
46	105	2	2015-04-24 16:20:00	2015-04-24 08:50:40.825941	2015-04-24 08:50:40.825941	\N	\N	\N	\N	0	\N	60
47	81	1	2015-04-26 00:00:00	2015-04-25 10:25:46.278112	2015-04-25 10:25:46.278112	测试团操	团操介绍	上海虹桥路933号	100	0	\N	60
3	4	1	2015-03-30 14:50:00	2015-03-30 06:50:20.504166	2015-04-27 08:57:50.730877	跑步-1000米	\N	\N	100	0	\N	60
\.


--
-- Name: tracks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('tracks_id_seq', 47, true);


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY transactions (id, no, order_no, source, buyer, price, created_at, updated_at) FROM stdin;
\.


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('transactions_id_seq', 1, true);


--
-- Data for Name: type_shows; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY type_shows (id, title, cover, url, content, created_at, updated_at) FROM stdin;
\.


--
-- Name: type_shows_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('type_shows_id_seq', 1, false);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY users (id, mobile, password, salt, created_at, updated_at, sns, device, views, status) FROM stdin;
38	13391078500	4f2fb7057a403e607ce738b1b49d09f5	j20dnk8xfa6b54oheg	2015-04-09 05:04:11.01708	2015-04-09 05:04:11.01708	\N		14000	1
39	15617656313	9d7e32ff47f5dd75ab64f063d1c5ca6e	u4v8xj9hyw5z7k6nbl	2015-04-09 05:53:31.628993	2015-04-09 05:53:31.628993	\N		14000	1
15	QQ_408A195EF65AC8831529420CAE3CBB7F	78df0e63393ae94b83e64a868f44f2ba	8jotsh17ywkp2grfx5	2015-04-07 08:43:29.322348	2015-04-07 08:43:29.322348	\N		14000	1
18	WeChat_ou14es_nQ4Qbu9dHs9ozUdQbAfWA	7cb7924db9ef592f8f3c9ea7fc6182f0	tyhmdoc62k5w10zaql	2015-04-07 09:08:16.883512	2015-04-07 09:08:16.883512	\N		14000	1
19	sina_2147228703	1301f48ba67b01202fb29c6858e68d9a	5a1er0mu943vsfljgy	2015-04-07 09:21:34.853311	2015-04-07 09:21:34.853311	\N		14000	1
20	qeqw	4c949de8f1f3903aceca9db4e589b327	v76dpfg1msjxo54zuc	2015-04-07 09:43:11.989331	2015-04-07 09:43:11.989331	\N		14000	1
21	qw	5daa33879e0c0ca5e67f97207294aa92	2bhv8ptafqs1gjlx36	2015-04-07 09:44:30.401171	2015-04-07 09:44:30.401171	\N		14000	1
22	w	1e1fe4e99745bcc3c45f38760e1b13a6	7yeljuwbv5dp0gtcra	2015-04-07 09:46:42.675848	2015-04-07 09:46:42.675848	\N		14000	1
23	das	6e4ce4b75988b4c9641ecf656694a7f6	9au5tknxh34yp86oqf	2015-04-07 09:53:45.381495	2015-04-07 09:53:45.381495	\N		14000	1
24	2132123	1d0973c1dff5fe63fb972382f47bfe7c	mvjwysl23egnqkd8p7	2015-04-08 01:40:22.22501	2015-04-08 01:40:22.22501	\N		14000	1
25	QQ_15877175	82c5c2bf6ea8f2b1623dc0e120f055a8	cjsh6klpabu7qz0d3o	2015-04-08 01:56:49.184365	2015-04-08 01:56:49.184365	\N		14000	1
27	QQ_CDB4453205646CBB2AC146AA0BA71E7C	2961f1068920581d282f14709cb75182	3wazes28dj49rv7utf	2015-04-08 02:58:50.813267	2015-04-08 02:58:50.813267	\N		14000	1
26	15026637572	3d55238cfafb424e165e2bd82694cc95	thz6bpwej0g2funlac	2015-04-08 02:00:44.025595	2015-04-08 08:28:21.49658	\N		14000	1
40	1213133113	779a27e4b8b595ffe521b1e2d6e4e89e	x4eidalzkbmcoqw5n7	2015-04-09 07:42:18.961489	2015-04-09 07:42:18.961489	\N		14000	1
41	1234567	9b22e856cc6d036c6315ae04142e1c9e	5qxtayd31bgspj4ioh	2015-04-09 08:06:37.413663	2015-04-09 08:06:37.413663	\N		14000	1
29	1876889520	60182a4b0d5096befbc4ebebadf3ba2d	c5lktbi6zhavfuy4e9	2015-04-09 02:29:30.076587	2015-04-09 02:29:30.076587	\N		14000	1
30	18221058659	eeb27c9211880a1d0d681f42cc08b838	6ltpi1bwjqzda5yc9u	2015-04-09 02:32:16.748018	2015-04-09 02:32:16.748018	\N		14000	1
31	111	c1c7d1a7374da53a28f775175acb819e	hw3gv5cl7fs14e9xap	2015-04-09 02:45:09.067663	2015-04-09 02:45:09.067663	\N		14000	1
42	1234	37dcaa927dfc57285f55e03d63847435	0hrbml41s58fiqadpt	2015-04-09 08:07:30.705654	2015-04-09 08:07:30.705654	\N		14000	1
32	123123	f5c731610986f4697d566da9a60ec8b3	753xmwz4lpo2qc8re1	2015-04-09 02:48:51.975469	2015-04-09 02:48:51.975469	\N		14000	1
43	123	df30b40e4a08ad3690a9bc1f38328bdb	8zt6ag2703smuwkoiq	2015-04-09 08:10:32.295116	2015-04-09 08:10:32.295116	\N		14000	1
45	2	4bb497e6b3f4d1002a78bab950b57546	cohgb65fae409lqj1i	2015-04-09 08:14:39.89153	2015-04-09 08:14:39.89153	\N		14000	1
46	3	5ed598e35d3e771dcfc6dbc926d0599f	ihpzo4gky87nralxds	2015-04-09 08:17:04.518272	2015-04-09 08:17:04.518272	\N		14000	1
47	4	bae36f198d3b4ae68a8db52a8eb8c650	k40tj6hixz7du8qswv	2015-04-09 08:18:04.701244	2015-04-09 08:18:04.701244	\N		14000	1
48	5	863d88df45911da9870c968379d38f17	n0rwbfap84zvmk2doy	2015-04-09 08:19:09.172772	2015-04-09 08:19:09.172772	\N		14000	1
49	11	4ee1e3d71ec5aa13282cd62c99463b29	ejox03hri8k5lasmyv	2015-04-09 08:22:03.156903	2015-04-09 08:22:03.156903	\N		14000	1
50	22	c98a5cb9c9e87dec296b7325dcd56bc6	hi94wbrne1mo8t5g3d	2015-04-09 08:24:56.203321	2015-04-09 08:24:56.203321	\N		14000	1
51	33	4afdcdd9a5f652a55da533baf2089bb3	nivq7ps82xjd1lwt30	2015-04-09 08:26:25.45479	2015-04-09 08:26:25.45479	\N		14000	1
52	121	1efdc24d3ae00ed025c198b60d355fb6	5f4wi3a9skulgp617t	2015-04-09 08:28:56.27855	2015-04-09 08:28:56.27855	\N		14000	1
53	21	300646104704fd796899445beb9f5ff8	ituvw80j5zqhbgxc4a	2015-04-09 08:42:55.957667	2015-04-09 08:42:55.957667	\N		14000	1
54	13	5b786233f8327ba12ce44142b988a881	6w8td7210kyapql3rn	2015-04-09 08:44:04.453946	2015-04-09 08:44:04.453946	\N		14000	1
79	meixing	cf6b6f56830544ef0f76eef37828a67c	ax7ufe6lbjnyvzwrt8	2015-04-13 02:17:19.018158	2015-04-13 02:17:19.018158	\N		14000	1
55	7	384a77d38ac425f7877fa1f0c17781da	rtyb5a6of2knwlgc70	2015-04-09 09:08:14.374179	2015-04-09 09:08:45.841985	\N		14000	1
56	QQ_8BC6EAC0BF7A0EC9129F30B4E590B8ED	fd332949cdf47c7d6f18bfdf50f3bcc5	qdhg6mujrzln0a85fy	2015-04-09 09:37:55.249978	2015-04-09 09:37:55.249978	\N		14000	1
58	11111111111	569fd290448fb95ed4386921d8478016	dk7nqy1fjs8etmrc09	2015-04-09 11:12:52.465931	2015-04-09 11:12:52.465931	\N		14000	1
59	11111111112	458256c1227571c92b63d2c1b98e1ac8	frszk2gyid1htoe4aq	2015-04-09 11:28:25.637304	2015-04-09 11:28:25.637304	\N		14000	1
57	13585753578	06797ef9be9eaa6dd8b74587ad6485a8	xound6l23yfqm5wt0j	2015-04-09 10:06:55.125035	2015-04-09 11:32:08.21414	\N		14000	1
37	18768895205	f2214084756244a4aa548260f1ce5044	f9qa02l5otu3gnwk48	2015-04-09 03:38:13.161248	2015-04-09 03:38:13.161248	\N		14000	1
76	123123123	5682cf0e8d3ce9e0743d6312429d2ba7	zxh21jn5k79ybtwme3	2015-04-11 09:00:06.502893	2015-04-11 09:00:06.502893	\N		14000	1
77	威尔士“长宁店	74188d2ea8174be998c95316bb9afd15	x716i5drysunvm2lcq	2015-04-13 02:15:55.637428	2015-04-13 02:15:55.637428	\N		14000	1
78	weiershi	de10ef52a34e0e973b1ff5f2681913ea	7bxayz62plj4me1vhn	2015-04-13 02:16:13.237237	2015-04-13 02:16:13.237237	\N		14000	1
80	15000111111	5311f1051bdc47ed5197eb0ee4f69654	a6om2r70itdy8wzeh4	2015-04-13 08:38:40.618551	2015-04-13 08:38:40.618551	\N		14000	1
84	sina_5147793485	bffd74bb8369aec943bb5a99ff0fad20	m7ps6fedzotuc3h8yn	2015-04-15 06:52:53.144601	2015-04-15 06:52:53.144601	\N		14000	1
85	WeChat_ou14es2YzgDFpECHRWiUg6HWsjCo	108e7c3551067bbeeae93ae0fc084c6d	107cymid9r2fn5qseb	2015-04-15 06:53:39.524691	2015-04-15 06:53:39.524691	\N		14000	1
86	WeChat_ou14es9vXy6f1GJcCpM6n38v594Y	339dea9fad6042d8841f9a4e313fd335	qgriw2e5y9fosan0zl	2015-04-15 07:12:55.86314	2015-04-15 07:12:55.86314	\N		14000	1
95	11111	3e7a194d038ce5cecfdb6610e4ba72a4	yamh1vold6wfz4p7xb	2015-04-16 05:56:37.537182	2015-04-16 05:56:37.537182	\N		14000	1
96	ceshi1	0e8dc19f82b46bea52cd65aff29659f1	r2con0gje183hutpsy	2015-04-16 06:31:43.799483	2015-04-16 06:31:43.799483	\N		14000	1
97	13585753579	a2c74965c5297c695ddc8488d830df8f	6ja58ine3tg74u0yoc	2015-04-16 06:34:17.555931	2015-04-16 06:34:17.555931	\N		14000	1
100	13916518973	3d3219b81efd891a95d983501936ce07	u6vxang9hbzwltkpy0	2015-04-18 03:38:41.090205	2015-04-18 03:38:41.090205	\N		14000	1
101	13585753566	8add59edfdf9511da91d3eb70114c7cf	i0l8fk74hs123tq69m	2015-04-18 04:02:24.09845	2015-04-18 04:02:24.09845	\N		14000	1
102	13585753533	685fd8a3ba24d7c7e920d06abb565fec	t6ql9u4o1j23f7pmyi	2015-04-18 04:03:19.547279	2015-04-18 04:03:19.547279	\N		14000	1
103	13585753511	dbe367dd35ddf319629f524d0b23c701	cr92g4qxzpfwnimkbe	2015-04-18 04:04:13.539243	2015-04-18 04:04:13.539243	\N		14000	1
104	sina_1950591014	267eca5f9f3eae0cc1c40c6f698203b8	2k3qsvn6h9j5pcm4io	2015-04-18 10:06:37.453818	2015-04-18 10:06:37.453818	\N		14000	1
17	b4163b23-9a32-47cb-a608-c0bff2f8e229	25660312256f5cc2fd44162d575dbe44	9m76naglsf28bq3pkh	2015-04-07 09:06:46.521885	2015-04-23 09:24:42.28187	\N		14000	1
82	15000111112	585e0460b9df6678203a3869d0ff6b5d	umckjetg2n93rfbwol	2015-04-13 10:18:43.113228	2015-04-27 04:12:18.939871	\N		14000	1
105	13916525963	85bb50e13078d8392d12d39d968b7023	qly2z0674c3kdg9mf5	2015-04-21 09:40:53.000491	2015-06-05 09:16:57.459828	\N		14000	1
108	13916518979	8268829f2b6c51788a8929603ced43ac	92jg0yrusoex1dz4ln	2015-06-23 06:58:32.616819	2015-06-23 06:58:32.616819	\N		14000	1
110	13916518999	e456732ca46c322ce173bee2f14b024e	4bfm62z8wjqyshur7c	2015-06-29 06:13:07.098005	2015-06-29 06:13:07.098005	\N		14000	1
4	18516691251	38f0137927dc98548a6028ff7cca4a6e	u9jmly86neq2t17rcd	2015-03-29 09:48:57.821272	2015-08-18 12:20:16.207943	\N	1	14000	1
141	11111111	a96c38e1c72a453fb117b67a467641bb	x1qibvnf3y09r4ghd2	2015-09-18 02:26:56.141295	2015-09-18 02:26:56.141295			14000	1
142		cb0245abc1b44a03f3700b923f00cb6b	9qhg3colm6x5n4juid	2015-09-23 10:57:05.523751	2015-09-23 10:57:05.523751			14000	1
143	123456789	24f9b04a7e70774c0313c9c1cd647777	orcgf7h5utn6pzwa2x	2015-09-24 11:13:21.202515	2015-09-24 11:13:21.202515			14000	1
81	5ce6c179-e325-43f2-abfb-3ae18c00a2a9	748f7d90eebd8f1147757882fcd189f2	e9ynl71hmtduij3gkp	2015-04-13 08:38:51.687506	2015-10-12 08:40:40.153805	925fed53-e13a-4040-93b5-a92a066a8c7b		14000	1
145	13916518971	123456789	\N	2015-10-12 10:12:23.236875	2015-10-12 10:12:23.236875			14000	1
146	13916518972	1111111111111	\N	2015-10-12 10:21:29.573628	2015-10-12 10:21:29.573628			14000	1
147	13585753573		\N	2015-10-12 11:15:47.65141	2015-10-12 11:15:47.65141			14000	1
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('users_id_seq', 149, true);


--
-- Data for Name: wallet_logs; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY wallet_logs (id, wallet_id, action, balance, coupons, bean, created_at, updated_at) FROM stdin;
1	66	211	200	[]	0	2015-07-17 12:31:53.074977	2015-07-17 12:31:53.074977
3	60	110	9890	[]	0	2015-07-18 02:36:36.728569	2015-07-18 02:36:36.728569
4	66	211	200	[]	0	2015-07-18 02:37:07.089689	2015-07-18 02:37:07.089689
5	60	211	-200	[]	0	2015-07-18 02:37:07.121528	2015-07-18 02:37:07.121528
6	60	210	-200	[]	0	2015-07-18 03:00:46.908422	2015-07-18 03:00:46.908422
7	60	210	-200	[]	0	2015-07-18 03:02:59.241256	2015-07-18 03:02:59.241256
8	60	210	-200	[]	0	2015-08-12 07:47:26.899832	2015-08-12 07:47:26.899832
9	60	210	-200	[]	0	2015-08-12 07:52:20.211228	2015-08-12 07:52:20.211228
10	60	210	-200	[]	0	2015-08-12 07:52:30.969723	2015-08-12 07:52:30.969723
11	60	210	-200	[]	0	2015-08-12 07:52:31.425912	2015-08-12 07:52:31.425912
12	60	210	-200	[]	0	2015-08-12 07:52:40.575879	2015-08-12 07:52:40.575879
13	60	210	-200	[]	0	2015-08-12 07:52:41.018618	2015-08-12 07:52:41.018618
14	60	210	-200	[]	0	2015-08-12 08:11:33.150334	2015-08-12 08:11:33.150334
15	60	\N	0	[]	10	2015-08-19 07:45:36.680271	2015-08-19 07:45:36.680271
16	60	\N	0	[]	0	2015-08-19 07:46:10.583886	2015-08-19 07:46:10.583886
17	60	\N	0	[]	2	2015-08-19 11:08:48.506399	2015-08-19 11:08:48.506399
18	60	\N	0	[]	1	2015-08-19 11:32:37.67775	2015-08-19 11:32:37.67775
19	60	\N	0	[]	0	2015-08-19 11:33:05.347177	2015-08-19 11:33:05.347177
20	60	\N	0	[]	-1	2015-08-19 12:06:27.330673	2015-08-19 12:06:27.330673
21	60	\N	0	[]	0	2015-08-19 12:06:46.661164	2015-08-19 12:06:46.661164
22	60	\N	0	[]	-7	2015-08-19 12:08:02.217639	2015-08-19 12:08:02.217639
23	67	211	11	[]	0	2015-09-15 12:08:13.356536	2015-09-15 12:08:13.356536
24	67	211	1	[]	0	2015-09-15 12:08:30.849046	2015-09-15 12:08:30.849046
25	68	110	10000	[]	0	2015-09-15 12:10:29.246473	2015-09-15 12:10:29.246473
26	67	211	100	[]	0	2015-09-15 12:10:45.920803	2015-09-15 12:10:45.920803
27	68	211	-100	[]	0	2015-09-15 12:10:45.94663	2015-09-15 12:10:45.94663
28	67	211	100	[]	0	2015-09-15 12:20:53.829676	2015-09-15 12:20:53.829676
29	68	211	-100	[]	0	2015-09-15 12:20:53.853865	2015-09-15 12:20:53.853865
30	67	211	100	[]	0	2015-09-15 12:21:03.606202	2015-09-15 12:21:03.606202
31	68	211	-100	[]	0	2015-09-15 12:21:03.62579	2015-09-15 12:21:03.62579
32	67	211	100	[]	0	2015-09-15 12:21:41.708611	2015-09-15 12:21:41.708611
33	68	211	-100	[]	0	2015-09-15 12:21:41.73544	2015-09-15 12:21:41.73544
34	67	211	100	[]	0	2015-09-16 07:37:49.654385	2015-09-16 07:37:49.654385
35	68	211	-100	[]	0	2015-09-16 07:37:49.690986	2015-09-16 07:37:49.690986
36	67	211	100	[]	0	2015-09-18 09:43:20.184155	2015-09-18 09:43:20.184155
37	68	211	-100	[]	0	2015-09-18 09:43:20.217042	2015-09-18 09:43:20.217042
38	68	210	-1000	[]	0	2015-09-23 07:25:23.225068	2015-09-23 07:25:23.225068
39	68	210	-400	[]	0	2015-09-23 07:26:19.629269	2015-09-23 07:26:19.629269
40	68	210	0	[]	0	2015-09-23 07:32:00.662847	2015-09-23 07:32:00.662847
41	67	211	100	[]	0	2015-09-24 11:16:57.87878	2015-09-24 11:16:57.87878
42	68	211	-100	[]	0	2015-09-24 11:16:57.908843	2015-09-24 11:16:57.908843
\.


--
-- Name: wallet_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('wallet_logs_id_seq', 42, true);


--
-- Data for Name: wallets; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY wallets (id, user_id, balance, bean, coupons, lock_version) FROM stdin;
61	81	0	0	{}	\N
62	80	0	0	{}	\N
63	56	0	0	{}	\N
64	58	0	0	{}	\N
66	\N	400.0	0	{}	\N
67	78	712.0	0	{}	9
68	51	7900.0	0	{}	10
69	55	0	0	{}	0
\.


--
-- Name: wallets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('wallets_id_seq', 69, true);


--
-- Data for Name: withdraws; Type: TABLE DATA; Schema: public; Owner: mxing_v2
--

COPY withdraws (id, coach_id, account, created_at, updated_at, name, amount, status) FROM stdin;
10	89	313423716@qq.com	2015-07-18 03:00:46.889638	2015-07-18 03:00:46.889638	郑军伟	200.0	1
11	89	313423716@qq.com	2015-07-18 03:02:59.238543	2015-07-18 03:02:59.238543	郑军伟	200.0	1
12	89	1	2015-08-12 07:47:26.859145	2015-08-12 07:47:26.859145	1	200.0	0
13	89	1	2015-08-12 07:52:20.202072	2015-08-12 07:52:20.202072	1	200.0	0
14	89	1	2015-08-12 07:52:30.966978	2015-08-12 07:52:30.966978	1	200.0	0
15	89	1	2015-08-12 07:52:31.423093	2015-08-12 07:52:31.423093	1	200.0	0
16	89	1	2015-08-12 07:52:40.57304	2015-08-12 07:52:40.57304	1	200.0	0
17	89	1	2015-08-12 07:52:41.015604	2015-08-12 07:52:41.015604	1	200.0	0
18	89	1	2015-08-12 08:11:33.142227	2015-08-12 08:11:33.142227	1	200.0	0
19	51	313423716@qq.com	2015-09-23 07:25:23.216582	2015-09-23 07:25:23.216582	郑军伟	1000.0	0
20	51	313423716@qq.com	2015-09-23 07:26:19.621801	2015-09-23 07:26:19.621801	郑军伟	400.0	0
21	51	313423716@qq.com	2015-09-23 07:32:00.652567	2015-09-23 07:32:00.652567	郑军伟	0	0
\.


--
-- Name: withdraws_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mxing_v2
--

SELECT pg_catalog.setval('withdraws_id_seq', 21, true);


--
-- Name: active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: address_coordinates_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY address_coordinates
    ADD CONSTRAINT address_coordinates_pkey PRIMARY KEY (id);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: ads_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: applies_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY applies
    ADD CONSTRAINT applies_pkey PRIMARY KEY (id);


--
-- Name: appointment_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY appointment_settings
    ADD CONSTRAINT appointment_settings_pkey PRIMARY KEY (id);


--
-- Name: appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: auto_logins_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY auto_logins
    ADD CONSTRAINT auto_logins_pkey PRIMARY KEY (id);


--
-- Name: banners_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: black_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY black_lists
    ADD CONSTRAINT black_lists_pkey PRIMARY KEY (id);


--
-- Name: blacklists_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY blacklists
    ADD CONSTRAINT blacklists_pkey PRIMARY KEY (id);


--
-- Name: captchas_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY captchas
    ADD CONSTRAINT captchas_pkey PRIMARY KEY (id);


--
-- Name: checks_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY checks
    ADD CONSTRAINT checks_pkey PRIMARY KEY (id);


--
-- Name: ckeditor_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY ckeditor_assets
    ADD CONSTRAINT ckeditor_assets_pkey PRIMARY KEY (id);


--
-- Name: coach_docs_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY coach_docs
    ADD CONSTRAINT coach_docs_pkey PRIMARY KEY (id);


--
-- Name: comment_images_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY comment_images
    ADD CONSTRAINT comment_images_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: companies_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_coaches_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY company_coaches
    ADD CONSTRAINT company_coaches_pkey PRIMARY KEY (id);


--
-- Name: company_shops_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY company_shops
    ADD CONSTRAINT company_shops_pkey PRIMARY KEY (id);


--
-- Name: concerneds_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY concerneds
    ADD CONSTRAINT concerneds_pkey PRIMARY KEY (id);


--
-- Name: coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- Name: course_abstracts_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY course_abstracts
    ADD CONSTRAINT course_abstracts_pkey PRIMARY KEY (id);


--
-- Name: course_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY course_addresses
    ADD CONSTRAINT course_addresses_pkey PRIMARY KEY (id);


--
-- Name: course_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY course_photos
    ADD CONSTRAINT course_photos_pkey PRIMARY KEY (id);


--
-- Name: courses_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: crawl_data_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY crawl_data
    ADD CONSTRAINT crawl_data_pkey PRIMARY KEY (id);


--
-- Name: devices_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (id);


--
-- Name: dynamic_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY dynamic_comments
    ADD CONSTRAINT dynamic_comments_pkey PRIMARY KEY (id);


--
-- Name: dynamic_films_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY dynamic_films
    ADD CONSTRAINT dynamic_films_pkey PRIMARY KEY (id);


--
-- Name: dynamic_images_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY dynamic_images
    ADD CONSTRAINT dynamic_images_pkey PRIMARY KEY (id);


--
-- Name: dynamics_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY dynamics
    ADD CONSTRAINT dynamics_pkey PRIMARY KEY (id);


--
-- Name: expiries_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY expiries
    ADD CONSTRAINT expiries_pkey PRIMARY KEY (id);


--
-- Name: feedbacks_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY feedbacks
    ADD CONSTRAINT feedbacks_pkey PRIMARY KEY (id);


--
-- Name: follows_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);


--
-- Name: galleries_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY galleries
    ADD CONSTRAINT galleries_pkey PRIMARY KEY (id);


--
-- Name: gallery_images_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY gallery_images
    ADD CONSTRAINT gallery_images_pkey PRIMARY KEY (id);


--
-- Name: group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (id);


--
-- Name: group_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY group_photos
    ADD CONSTRAINT group_photos_pkey PRIMARY KEY (id);


--
-- Name: group_places_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY group_places
    ADD CONSTRAINT group_places_pkey PRIMARY KEY (id);


--
-- Name: groups_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: hit_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY hit_reports
    ADD CONSTRAINT hit_reports_pkey PRIMARY KEY (id);


--
-- Name: hits_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY hits
    ADD CONSTRAINT hits_pkey PRIMARY KEY (id);


--
-- Name: lessons_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY lessons
    ADD CONSTRAINT lessons_pkey PRIMARY KEY (id);


--
-- Name: likes_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


--
-- Name: mass_message_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY mass_message_groups
    ADD CONSTRAINT mass_message_groups_pkey PRIMARY KEY (id);


--
-- Name: mass_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY mass_messages
    ADD CONSTRAINT mass_messages_pkey PRIMARY KEY (id);


--
-- Name: news_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY news
    ADD CONSTRAINT news_pkey PRIMARY KEY (id);


--
-- Name: online_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY online_reports
    ADD CONSTRAINT online_reports_pkey PRIMARY KEY (id);


--
-- Name: onlines_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY onlines
    ADD CONSTRAINT onlines_pkey PRIMARY KEY (id);


--
-- Name: order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: overviews_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY overviews
    ADD CONSTRAINT overviews_pkey PRIMARY KEY (id);


--
-- Name: photos_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY photos
    ADD CONSTRAINT photos_pkey PRIMARY KEY (id);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: recommends_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY recommends
    ADD CONSTRAINT recommends_pkey PRIMARY KEY (id);


--
-- Name: reports_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: retentions_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY retentions
    ADD CONSTRAINT retentions_pkey PRIMARY KEY (id);


--
-- Name: service_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY service_courses
    ADD CONSTRAINT service_courses_pkey PRIMARY KEY (id);


--
-- Name: service_members_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY service_members
    ADD CONSTRAINT service_members_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: showtimes_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY showtimes
    ADD CONSTRAINT showtimes_pkey PRIMARY KEY (id);


--
-- Name: skus_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY skus
    ADD CONSTRAINT skus_pkey PRIMARY KEY (id);


--
-- Name: tracks_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY tracks
    ADD CONSTRAINT tracks_pkey PRIMARY KEY (id);


--
-- Name: transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: type_shows_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY type_shows
    ADD CONSTRAINT type_shows_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wallet_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY wallet_logs
    ADD CONSTRAINT wallet_logs_pkey PRIMARY KEY (id);


--
-- Name: wallets_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY wallets
    ADD CONSTRAINT wallets_pkey PRIMARY KEY (id);


--
-- Name: withdraws_pkey; Type: CONSTRAINT; Schema: public; Owner: mxing_v2; Tablespace: 
--

ALTER TABLE ONLY withdraws
    ADD CONSTRAINT withdraws_pkey PRIMARY KEY (id);


--
-- Name: idx_ckeditor_assetable; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX idx_ckeditor_assetable ON ckeditor_assets USING btree (assetable_type, assetable_id);


--
-- Name: idx_ckeditor_assetable_type; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX idx_ckeditor_assetable_type ON ckeditor_assets USING btree (assetable_type, type, assetable_id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_namespace ON active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_address_coordinates_on_lonlat; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_address_coordinates_on_lonlat ON address_coordinates USING gist (lonlat);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_email ON admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON admin_users USING btree (reset_password_token);


--
-- Name: index_appointments_on_code; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE UNIQUE INDEX index_appointments_on_code ON appointments USING btree (code);


--
-- Name: index_course_abstracts_on_coordinate; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_course_abstracts_on_coordinate ON course_abstracts USING gist (coordinate);


--
-- Name: index_dynamic_comments_on_dynamic_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_dynamic_comments_on_dynamic_id ON dynamic_comments USING btree (dynamic_id);


--
-- Name: index_group_places_on_lonlat; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_group_places_on_lonlat ON group_places USING gist (lonlat);


--
-- Name: index_likes_on_liked_id_and_like_type; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_likes_on_liked_id_and_like_type ON likes USING btree (liked_id, like_type);


--
-- Name: index_order_items_on_order_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_order_items_on_order_id ON order_items USING btree (order_id);


--
-- Name: index_places_on_lonlat; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_places_on_lonlat ON places USING gist (lonlat);


--
-- Name: index_profiles_on_address; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_profiles_on_address ON profiles USING btree (address);


--
-- Name: index_profiles_on_name; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_profiles_on_name ON profiles USING btree (name);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--
-- Name: index_service_members_on_coach_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_service_members_on_coach_id ON service_members USING btree (coach_id);


--
-- Name: index_service_members_on_service_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_service_members_on_service_id ON service_members USING btree (service_id);


--
-- Name: index_skus_on_coordinate; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_skus_on_coordinate ON skus USING gist (coordinate);


--
-- Name: index_skus_on_seller_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_skus_on_seller_id ON skus USING btree (seller_id);


--
-- Name: index_skus_on_service_id; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE INDEX index_skus_on_service_id ON skus USING btree (service_id);


--
-- Name: index_skus_on_sku; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE UNIQUE INDEX index_skus_on_sku ON skus USING btree (sku);


--
-- Name: index_users_on_mobile_and_sns; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_mobile_and_sns ON users USING btree (mobile, sns);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: mxing_v2; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

