do $$
declare
  schema_record RECORD;
  table_record RECORD;
  duplicate_count int;
  table_count int;
  count_of_duplicates int:= 0;
  researched_table text;
begin
  -- Цикл по всем схемам внутри бд
  for schema_record in select schema_name from information_schema.schemata where schema_name  not in ('information_schema', 'pg_catalog') loop

   raise notice 'Схема %', schema_record.schema_name;

   for table_record in select table_name from information_schema.tables where table_schema =  schema_record.schema_name loop
   researched_table := schema_record.schema_name ||'.'|| table_record.table_name;

   execute
  'with t as (
    select
      count(*)
    from ' || researched_table || '
    group by ' || researched_table||'.*
    having count(*) > 1
  )
  select count(*) from t'
  into count_of_duplicates
  ;
     raise notice 'Таблица - %  Дубликаты - %', table_record.table_name, count_of_duplicates;
   end loop;

 end loop;

  raise notice 'ПРОВЕРКА ОКОНЧЕНА';
end $$;