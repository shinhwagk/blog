declare
   st VARCHAR(1024);
   val number;
begin
  for seq in (SELECT * FROM DBA_SEQUENCES s WHERE s.sequence_owner='UES') loop
    dbms_output.put_line(seq.sequence_owner||'.'||seq.sequence_name||' ' ||seq.cache_size);
    for cnt in 1..seq.cache_size loop
       st := 'select '||seq.sequence_owner||'.'||seq.sequence_name||'.nextval from dual';
       execute immediate st into val;
   end loop;
 end loop;
end;
/
