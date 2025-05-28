select * from [Students_Partitioned_One]
where tenant_id = 9 and tenant_partition = 9 and student_id = 50

select * from [Students_Partitioned_One]
where tenant_id = 9 and tenant_partition = 9 and full_name like 'Aluno_50_%'
