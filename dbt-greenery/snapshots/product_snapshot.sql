{% snapshot product_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='product_id',

      strategy='check',
      check_cols=['quantity']
    )
  }}

  SELECT * 
  FROM {{ source('greenery', 'products') }}

{% endsnapshot %}