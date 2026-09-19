-- ============================================================
-- نموذج حصر المنشآت وفرص الشراكة — إعداد قاعدة البيانات
-- المشروع: akawkmoygfhdmzcoqfly
-- يُنشئ جدولًا جديدًا مستقلًا فقط. لا يعدّل ولا يحذف أي جدول قائم.
-- شغّله مرة واحدة من: Supabase → SQL Editor → New query → Run
-- ============================================================

create table if not exists public.csr_partnership_responses (
  id                  uuid primary key default gen_random_uuid(),
  created_at          timestamptz not null default now(),

  -- بيانات المنشأة
  org_name            text not null,
  region              text,
  org_size            text,
  business_activity   text,
  contact_name        text not null,
  job_title           text not null,
  email               text not null,
  phone               text not null,

  -- مجالات الاهتمام
  has_programs        text,
  initiatives_on_platform text,
  target_groups       text[] default '{}',
  target_groups_other text,

  -- فرص الشراكة
  contribution_types  text[] default '{}',
  contribution_other  text,
  existing_initiative text,
  collaboration_details text,

  -- التواصل والمتابعة
  registered_platform text,
  wants_coordination  text,
  coordination_other  text,
  wants_department    text,
  has_officer         text,
  notes               text,

  -- نسخة كاملة من الإجابة كما وصلت (شبكة أمان)
  payload             jsonb
);

comment on table public.csr_partnership_responses is 'ردود نموذج حصر المنشآت وفرص الشراكة في المسؤولية الاجتماعية';

create index if not exists csr_partnership_responses_created_at_idx
  on public.csr_partnership_responses (created_at desc);

-- حماية الصفوف: الزائر يستطيع الإضافة فقط، ولا يستطيع القراءة أو التعديل أو الحذف
alter table public.csr_partnership_responses enable row level security;

drop policy if exists "insert_from_form" on public.csr_partnership_responses;
create policy "insert_from_form"
  on public.csr_partnership_responses
  for insert
  to anon, authenticated
  with check (true);

-- لا توجد سياسة select/update/delete عمدًا:
-- الاطلاع على الردود يتم من لوحة تحكم Supabase أو بمفتاح service_role فقط.
