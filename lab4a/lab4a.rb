#Your code goes here
import 'org.apache.hadoop.hbase.client.HTable'
import 'org.apache.hadoop.hbase.client.Put'

def jbytes( *args )
  args.map { |arg| arg.to_s.to_java_bytes }
end

def put_many( table_name, row, column_values)

  table = HTable.new( @hbase.configuration, table_name )
  p = Put.new( *jbytes( row ))
  column_values.each do |key, value| 
     col = key.split( ":", 2 )
     column_family = col[0]
     column_qualifier = col[1]
     p.add( column_family, column_qualifier, value )
  end

  table.put( p )
end

put_many 'wiki', 'My Title', {
  "text:" => "A made up text block",
  "revision:author" => "Shawn Crahen",
  "revision:comment" => "Ruby is fun!" }

get 'wiki', 'My Title'

#Do not remove the exit call below
exit
