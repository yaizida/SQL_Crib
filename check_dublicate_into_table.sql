With dt as (
  Select
   *,
   row_number() over (partition by
    <Перечислить все поля таблицы>
   	) as rowNumber
  from <имя_схемы.имя_таблицы>
)
select * from dt where rowNumber > 1