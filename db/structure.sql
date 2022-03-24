SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: discord_channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.discord_channels (
    id bigint NOT NULL,
    channel_id character varying NOT NULL,
    guild_id character varying NOT NULL,
    name character varying NOT NULL,
    description character varying,
    last_loaded timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: discord_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.discord_channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: discord_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.discord_channels_id_seq OWNED BY public.discord_channels.id;


--
-- Name: filters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.filters (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    comparison character varying,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: filters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.filters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: filters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.filters_id_seq OWNED BY public.filters.id;


--
-- Name: rss_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rss_items (
    id bigint NOT NULL,
    itemable_type character varying NOT NULL,
    itemable_id bigint NOT NULL,
    title character varying NOT NULL,
    link character varying NOT NULL,
    published_at timestamp(6) without time zone NOT NULL,
    description text,
    guid character varying NOT NULL,
    media_title character varying,
    media_url character varying,
    media_type character varying,
    media_width integer,
    media_height integer,
    media_thumbnail_url character varying,
    media_thumbnail_width integer,
    media_thumbnail_height integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    enclosure_length integer,
    enclosure_type character varying,
    enclosure_url character varying,
    itunes_duration integer,
    itunes_episode_type character varying,
    itunes_author character varying,
    itunes_explicit boolean,
    itunes_image character varying
);


--
-- Name: rss_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rss_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rss_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rss_items_id_seq OWNED BY public.rss_items.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subscriptions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    subscriptable_type character varying NOT NULL,
    subscriptable_id bigint NOT NULL,
    uuid text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.subscriptions_id_seq OWNED BY public.subscriptions.id;


--
-- Name: tweets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tweets (
    id bigint NOT NULL,
    twitter_user_id bigint NOT NULL,
    tweet_id character varying NOT NULL,
    text text NOT NULL,
    title text NOT NULL,
    tweeted_at timestamp(6) without time zone NOT NULL,
    source character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: tweets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tweets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tweets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tweets_id_seq OWNED BY public.tweets.id;


--
-- Name: twitter_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.twitter_users (
    id bigint NOT NULL,
    last_loaded timestamp(6) without time zone,
    twitter_id character varying NOT NULL,
    name character varying NOT NULL,
    username character varying NOT NULL,
    description character varying,
    profile_image_url character varying,
    url character varying,
    verified boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: twitter_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.twitter_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: twitter_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.twitter_users_id_seq OWNED BY public.twitter_users.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp(6) without time zone,
    last_sign_in_at timestamp(6) without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp(6) without time zone,
    confirmation_sent_at timestamp(6) without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    uuid text NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: websites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.websites (
    id bigint NOT NULL,
    last_loaded timestamp(6) without time zone,
    url character varying,
    rss_url character varying,
    name character varying,
    image_url character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: websites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.websites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: websites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.websites_id_seq OWNED BY public.websites.id;


--
-- Name: youtube_channels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.youtube_channels (
    id bigint NOT NULL,
    last_loaded timestamp(6) without time zone,
    url character varying NOT NULL,
    rss_url character varying NOT NULL,
    name character varying NOT NULL,
    image_url character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: youtube_channels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.youtube_channels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: youtube_channels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.youtube_channels_id_seq OWNED BY public.youtube_channels.id;


--
-- Name: youtube_rss_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.youtube_rss_entries (
    id bigint NOT NULL,
    youtube_channel_id bigint NOT NULL,
    published_at timestamp(6) without time zone NOT NULL,
    entry_id character varying NOT NULL,
    data json NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: youtube_rss_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.youtube_rss_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: youtube_rss_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.youtube_rss_entries_id_seq OWNED BY public.youtube_rss_entries.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discord_channels ALTER COLUMN id SET DEFAULT nextval('public.discord_channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filters ALTER COLUMN id SET DEFAULT nextval('public.filters_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rss_items ALTER COLUMN id SET DEFAULT nextval('public.rss_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions ALTER COLUMN id SET DEFAULT nextval('public.subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweets ALTER COLUMN id SET DEFAULT nextval('public.tweets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.twitter_users ALTER COLUMN id SET DEFAULT nextval('public.twitter_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.websites ALTER COLUMN id SET DEFAULT nextval('public.websites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.youtube_channels ALTER COLUMN id SET DEFAULT nextval('public.youtube_channels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.youtube_rss_entries ALTER COLUMN id SET DEFAULT nextval('public.youtube_rss_entries_id_seq'::regclass);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: discord_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.discord_channels
    ADD CONSTRAINT discord_channels_pkey PRIMARY KEY (id);


--
-- Name: filters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filters
    ADD CONSTRAINT filters_pkey PRIMARY KEY (id);


--
-- Name: rss_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rss_items
    ADD CONSTRAINT rss_items_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: tweets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweets
    ADD CONSTRAINT tweets_pkey PRIMARY KEY (id);


--
-- Name: twitter_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.twitter_users
    ADD CONSTRAINT twitter_users_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: websites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.websites
    ADD CONSTRAINT websites_pkey PRIMARY KEY (id);


--
-- Name: youtube_channels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.youtube_channels
    ADD CONSTRAINT youtube_channels_pkey PRIMARY KEY (id);


--
-- Name: youtube_rss_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.youtube_rss_entries
    ADD CONSTRAINT youtube_rss_entries_pkey PRIMARY KEY (id);


--
-- Name: index_discord_channels_on_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_discord_channels_on_channel_id ON public.discord_channels USING btree (channel_id);


--
-- Name: index_discord_channels_on_last_loaded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_discord_channels_on_last_loaded ON public.discord_channels USING btree (last_loaded);


--
-- Name: index_filters_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_filters_on_user_id ON public.filters USING btree (user_id);


--
-- Name: index_filters_on_user_id_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_filters_on_user_id_and_value ON public.filters USING btree (user_id, value);


--
-- Name: index_rss_items_on_itemable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rss_items_on_itemable ON public.rss_items USING btree (itemable_type, itemable_id);


--
-- Name: index_rss_items_on_itemable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rss_items_on_itemable_id ON public.rss_items USING btree (itemable_id);


--
-- Name: index_rss_items_on_itemable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rss_items_on_itemable_type ON public.rss_items USING btree (itemable_type);


--
-- Name: index_rss_items_on_itemable_type_and_itemable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rss_items_on_itemable_type_and_itemable_id ON public.rss_items USING btree (itemable_type, itemable_id);


--
-- Name: index_rss_items_on_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rss_items_on_published_at ON public.rss_items USING btree (published_at);


--
-- Name: index_subscriptions_on_subscriptable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_subscriptable ON public.subscriptions USING btree (subscriptable_type, subscriptable_id);


--
-- Name: index_subscriptions_on_subscriptable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_subscriptable_id ON public.subscriptions USING btree (subscriptable_id);


--
-- Name: index_subscriptions_on_subscriptable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_subscriptable_type ON public.subscriptions USING btree (subscriptable_type);


--
-- Name: index_subscriptions_on_subscriptable_type_and_subscriptable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_subscriptable_type_and_subscriptable_id ON public.subscriptions USING btree (subscriptable_type, subscriptable_id);


--
-- Name: index_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_user_id ON public.subscriptions USING btree (user_id);


--
-- Name: index_subscriptions_on_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_subscriptions_on_uuid ON public.subscriptions USING btree (uuid);


--
-- Name: index_tweets_on_tweet_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_tweet_id ON public.tweets USING btree (tweet_id);


--
-- Name: index_tweets_on_tweeted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_tweeted_at ON public.tweets USING btree (tweeted_at);


--
-- Name: index_tweets_on_twitter_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tweets_on_twitter_user_id ON public.tweets USING btree (twitter_user_id);


--
-- Name: index_twitter_users_on_last_loaded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_twitter_users_on_last_loaded ON public.twitter_users USING btree (last_loaded);


--
-- Name: index_twitter_users_on_twitter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_twitter_users_on_twitter_id ON public.twitter_users USING btree (twitter_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_websites_on_last_loaded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_websites_on_last_loaded ON public.websites USING btree (last_loaded);


--
-- Name: index_websites_on_rss_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_websites_on_rss_url ON public.websites USING btree (rss_url);


--
-- Name: index_youtube_channels_on_last_loaded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_youtube_channels_on_last_loaded ON public.youtube_channels USING btree (last_loaded);


--
-- Name: index_youtube_channels_on_rss_url; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_youtube_channels_on_rss_url ON public.youtube_channels USING btree (rss_url);


--
-- Name: index_youtube_rss_entries_on_entry_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_youtube_rss_entries_on_entry_id ON public.youtube_rss_entries USING btree (entry_id);


--
-- Name: index_youtube_rss_entries_on_published_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_youtube_rss_entries_on_published_at ON public.youtube_rss_entries USING btree (published_at);


--
-- Name: index_youtube_rss_entries_on_youtube_channel_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_youtube_rss_entries_on_youtube_channel_id ON public.youtube_rss_entries USING btree (youtube_channel_id);


--
-- Name: sub_user_full_subscriptable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sub_user_full_subscriptable ON public.subscriptions USING btree (user_id, subscriptable_type, subscriptable_id);


--
-- Name: fk_rails_20178f629d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.youtube_rss_entries
    ADD CONSTRAINT fk_rails_20178f629d FOREIGN KEY (youtube_channel_id) REFERENCES public.youtube_channels(id);


--
-- Name: fk_rails_933bdff476; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_rails_933bdff476 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fk_rails_9f72e519dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tweets
    ADD CONSTRAINT fk_rails_9f72e519dd FOREIGN KEY (twitter_user_id) REFERENCES public.twitter_users(id);


--
-- Name: fk_rails_f53aed9bb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.filters
    ADD CONSTRAINT fk_rails_f53aed9bb6 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20220223033249'),
('20220223035136'),
('20220223035219'),
('20220223035444'),
('20220310083144'),
('20220311052115'),
('20220312001317'),
('20220312052726'),
('20220317080236'),
('20220317231447'),
('20220319183509'),
('20220324075856');


