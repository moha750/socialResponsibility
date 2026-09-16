-- ============================================================
-- لوحة ردود حصر المنشآت — صلاحية القراءة
-- المشروع: akawkmoygfhdmzcoqfly
-- شغّله مرة واحدة من: Supabase → SQL Editor → New query → Run
-- لا يعدّل جدول الردود ولا أي جدول قائم، ولا يمنح أحدًا حق الحذف أو التعديل.
-- ============================================================

-- 1) قائمة من يحق لهم فتح اللوحة (بريد الحساب في Supabase Auth)
create table if not exists public.csr_dashboard_admins (
  email    text primary key,
  added_at timestamptz not null default now()
);

-- الجدول مقفل تمامًا أمام المتصفح: RLS مفعّل بلا أي سياسة
alter table public.csr_dashboard_admins enable row level security;

-- أضف هنا بريد كل شخص يُسمح له بالدخول (نفس البريد المسجّل في Authentication → Users)
insert into public.csr_dashboard_admins (email) values
  ('S.A.Aldawsari010@hrsd.gov.sa')
on conflict (email) do nothing;

-- 2) دالة فحص الصلاحية (تتجاوز قفل الجدول أعلاه بأمان)
create or replace function public.is_csr_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.csr_dashboard_admins a
    where lower(a.email) = lower(auth.jwt() ->> 'email')
  );
$$;

revoke all on function public.is_csr_admin() from public, anon;
grant execute on function public.is_csr_admin() to authenticated;

-- 3) سياسة القراءة: القراءة فقط، ولمن هو في القائمة فقط
drop policy if exists "dashboard_read" on public.csr_partnership_responses;
create policy "dashboard_read"
  on public.csr_partnership_responses
  for select
  to authenticated
  using (public.is_csr_admin());

-- ============================================================
-- خطوات يدوية مطلوبة بعد تشغيل الملف:
--
-- أ) إنشاء حساب الدخول:
--    Authentication → Users → Add user
--    أدخل البريد وكلمة المرور، وفعّل Auto Confirm User.
--
-- ب) إغلاق التسجيل الذاتي (مهم):
--    Authentication → Sign In / Providers → Email
--    أوقف "Allow new users to sign up".
--    بدونه يستطيع أي شخص إنشاء حساب في المشروع؛ ولن يقرأ الردود
--    لأن السياسة أعلاه تشترط وجوده في قائمة csr_dashboard_admins،
--    لكن إغلاق التسجيل يمنع إنشاء الحسابات من الأساس.
--
-- ج) لإضافة شخص لاحقًا:
--    insert into public.csr_dashboard_admins (email) values ('name@hrsd.gov.sa');
--
-- د) لإيقاف صلاحية شخص:
--    delete from public.csr_dashboard_admins where email = 'name@hrsd.gov.sa';
-- ============================================================
