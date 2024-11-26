create or replace function get_recommendations_by_user_iin_id(user_iin varchar(20), user_id_ uuid)
    returns setof movie
as
$$
begin
    return query select *
                 from public.movie
                 where movie_id in (select movie_id
                                    from public.user_recommendation
                                    where iin = user_iin
                                      and movie_id not in
                                          (select movie_id from public.reaction where user_id = user_id_));
end;
$$
    language plpgsql;

create or replace function get_recommendations_by_device_id(_device_id uuid)
    returns setof movie
as
$$
BEGIN

    return query select (get_recommendations_by_user_iin_id(iin, user_id)).*
                 from public."user"
                 where device_id = _device_id;
end;
$$
    language plpgsql;

create or replace function get_recommendations_by_user_id(_user_id uuid)
    returns setof movie
as
$$
BEGIN

    return query select (get_recommendations_by_user_iin_id(iin, user_id)).*
                 from public."user"
                 where user_id = _user_id;
end;
$$
    language plpgsql;


