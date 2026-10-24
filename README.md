# Boutique de mariage — Vercel + Supabase (aucune variable d'environnement)

## 1. Créer la base (gratuit)
1. Sur supabase.com : New project.
2. **Authentication → Users → Add user** : e-mail + mot de passe de l'administrateur (cochez « Auto confirm »).
   Puis **Authentication → Sign In / Providers** : désactivez « Allow new users to sign up ».
3. Ouvrez `supabase.sql`, remplacez `proprietaire@exemple.com` par l'e-mail de l'étape 2, puis collez le tout dans **SQL Editor → Run**.
4. **Project Settings → API** : copiez « Project URL » et la clé « anon public » dans `public/config.js`.

## 2. Mettre en ligne
Envoyez le contenu de ce dossier sur GitHub, puis sur vercel.com : Add New → Project → importez le dépôt (aucun réglage).

## 3. Utiliser
`https://votre-site.vercel.app/admin` : connexion par e-mail et mot de passe.
Articles (ajout, modification, photo, mise en vente ou retrait), catégories, nom de la boutique et numéro WhatsApp (ex. `237600000000`).
Chaque changement est visible immédiatement sur la boutique.
