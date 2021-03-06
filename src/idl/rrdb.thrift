include "dsn.thrift"

namespace cpp dsn.apps

struct update_request
{
    1:dsn.blob      key;
    2:dsn.blob      value;
    3:i32           expire_ts_seconds;
}

struct update_response
{
    1:i32           error;
    2:i32           app_id;
    3:i32           partition_index;
    4:i64           decree;
    5:string        server;
}

struct read_response
{
    1:i32           error;
    2:dsn.blob      value;
    3:i32           app_id;
    4:i32           partition_index;
    6:string        server;
}

struct ttl_response
{
    1:i32           error;
    2:i32           ttl_seconds;
    3:i32           app_id;
    4:i32           partition_index;
    6:string        server;
}

struct count_response
{
    1:i32           error;
    2:i64           count;
    3:i32           app_id;
    4:i32           partition_index;
    6:string        server;
}

struct key_value
{
    1:dsn.blob      key;
    2:dsn.blob      value;
}

struct multi_put_request
{
    1:dsn.blob      hash_key;
    2:list<key_value> kvs; // sort_key => value
    3:i32           expire_ts_seconds;
}

struct multi_remove_request
{
    1:dsn.blob      hash_key;
    2:list<dsn.blob> sort_keys; // should not be empty
    3:i64           max_count; // deprecated
}

struct multi_remove_response
{
    1:i32           error;
    2:i64           count; // deleted count
    3:i32           app_id;
    4:i32           partition_index;
    5:i64           decree;
    6:string        server;
}

struct multi_get_request
{
    1:dsn.blob      hash_key;
    2:list<dsn.blob> sort_keys; // empty means fetch all sortkeys
    3:i32           max_kv_count; // <= 0 means no limit
    4:i32           max_kv_size; // <= 0 means no limit
    5:bool          no_value; // not return value, only return sortkeys
}

struct multi_get_response
{
    1:i32           error;
    2:list<key_value> kvs; // sort_key => value
    3:i32           app_id;
    4:i32           partition_index;
    6:string        server;
}

struct incr_request
{
    1:dsn.blob      key;
    2:i64           increment;
}

struct get_scanner_request
{
    1:dsn.blob  start_key;
    2:dsn.blob  stop_key;
    3:bool      start_inclusive;
    4:bool      stop_inclusive;
    5:i32       batch_size;
}

struct scan_request
{
    1:i64           context_id;
}

struct scan_response
{
    1:i32           error;
    2:list<key_value> kvs;
    3:i64           context_id;
    4:i32           app_id;
    5:i32           partition_index;
    6:string        server;
}

service rrdb
{
    update_response put(1:update_request update);
    update_response multi_put(1:multi_put_request request);
    update_response remove(1:dsn.blob key);
    multi_remove_response multi_remove(1:multi_remove_request request);
    read_response get(1:dsn.blob key);
    multi_get_response multi_get(1:multi_get_request request);
    count_response sortkey_count(1:dsn.blob hash_key);
    ttl_response ttl(1:dsn.blob key);

    scan_response get_scanner(1:get_scanner_request request);
    scan_response scan(1:scan_request request);
    oneway void clear_scanner(1:i64 context_id);
}

