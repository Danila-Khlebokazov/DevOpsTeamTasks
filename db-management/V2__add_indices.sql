create unique index user_device_id_idx on public."user" (device_id);
create unique index user_user_id_idx on public."user" (user_id);
create unique index movie_movie_id_idx on public.movie (movie_id);
create index user_recommendation_iin_idx on public.user_recommendation (iin);
create index reaction_user_id_idx on public.reaction (user_id);
