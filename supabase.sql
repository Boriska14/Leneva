-- À exécuter une seule fois dans Supabase : SQL Editor → New query → Run
-- 1) REMPLACEZ l'adresse ci-dessous par l'e-mail du compte administrateur
create or replace function public.is_admin() returns boolean language sql stable as $$
  select coalesce(auth.jwt() ->> 'email', '') = 'ayinaleonie1@gmail.com'
$$;

create table public.settings (
  id int primary key default 1 check (id = 1),
  name text not null default 'Maison Éternelle',
  tagline text not null default 'Robes de mariée & accessoires',
  whatsapp text not null default '33600000000',
  currency text not null default '€'
);
insert into public.settings default values;

create table public.categories (
  id bigint generated always as identity primary key,
  name text not null unique,
  position int not null default 0
);
create table public.products (
  id bigint generated always as identity primary key,
  name text not null,
  category_id bigint references public.categories(id) on delete restrict,
  price numeric not null default 0,
  description text default '',
  image text default '',
  available boolean not null default true,
  created_at timestamptz default now()
);

alter table public.settings enable row level security;
alter table public.categories enable row level security;
alter table public.products enable row level security;
create policy "lecture publique" on public.settings for select using (true);
create policy "lecture publique" on public.categories for select using (true);
create policy "lecture publique" on public.products for select using (true);
create policy "admin" on public.settings for all using (public.is_admin()) with check (public.is_admin());
create policy "admin" on public.categories for all using (public.is_admin()) with check (public.is_admin());
create policy "admin" on public.products for all using (public.is_admin()) with check (public.is_admin());

insert into storage.buckets (id, name, public) values ('photos', 'photos', true) on conflict do nothing;
create policy "photos lecture" on storage.objects for select using (bucket_id = 'photos');
create policy "photos admin" on storage.objects for all using (bucket_id = 'photos' and public.is_admin()) with check (bucket_id = 'photos' and public.is_admin());

-- Exemples (modifiables ensuite dans l'admin)
insert into public.categories (name, position) values ('Robes de mariée',1),('Voiles',2),('Bijoux',3),('Chaussures',4),('Accessoires',5);
insert into public.products (name, category_id, price, description)
select v.n, c.id, v.p, v.d from (values
 ('Robe Céleste','Robes de mariée',1450,'Coupe sirène, dentelle fine et dos en V.'),
 ('Robe Aurore','Robes de mariée',1890,'Jupe en tulle volumineuse, corset ajusté.'),
 ('Voile cathédrale','Voiles',180,'Voile long bordé de dentelle, 3 mètres.'),
 ('Collier perles','Bijoux',95,'Perles de culture, fermoir doré.'),
 ('Escarpins nacrés','Chaussures',140,'Talon 7 cm, satin nacré.')
) as v(n,cat,p,d) join public.categories c on c.name = v.cat;
