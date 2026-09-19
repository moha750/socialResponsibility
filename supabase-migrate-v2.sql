-- ============================================================
-- تحديث جدول الردود — إضافة حقول مراجعة الفريق
-- شغّله مرة واحدة في: Supabase → SQL Editor
-- آمن للتكرار، ولا يمسّ أي بيانات موجودة.
-- ============================================================

alter table public.csr_partnership_responses
  add column if not exists region                  text,  -- مقر المنشأة (المنطقة)
  add column if not exists org_size                text,  -- صغرى / متوسطة / كبيرة / عملاقة
  add column if not exists business_activity       text,  -- النشاط التجاري
  add column if not exists initiatives_on_platform text,  -- إدراج المبادرات في المنصة: نعم / لا / بعضًا منها
  add column if not exists collaboration_details   text;  -- تفاصيل المبادرة المطلوب التعاون بشأنها

comment on column public.csr_partnership_responses.region is 'المنطقة الإدارية لمقر المنشأة';
comment on column public.csr_partnership_responses.org_size is 'حجم المنشأة: صغرى، متوسطة، كبيرة، عملاقة';
comment on column public.csr_partnership_responses.initiatives_on_platform is 'هل أُدرجت مبادرات المنشأة في المنصة الوطنية';
