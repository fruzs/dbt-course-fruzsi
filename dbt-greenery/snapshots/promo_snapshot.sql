{% snapshot promo_snapshot %}

  {{
    config(
      target_schema='snapshots',
      unique_key='promo_id',

      strategy='check',
      check_cols=['status']
    )
  }}

  SELECT * 
  FROM {{ source('greenery', 'promos') }}

{% endsnapshot %}