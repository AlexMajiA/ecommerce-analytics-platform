{%snapshot snapshot_order_items%}
{{
    config(
        target_schema = 'snapshots',
        unique_key = ['order_id','order_item_id'],
        strategy = 'timestamp',
        updated_at = 'ingest_timestamp'
    )
}}

    select *
    from
        {{ref('stg_order_items')}}
        
{% endsnapshot %}