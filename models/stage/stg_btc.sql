{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = 'HASH_KEY'
) }}

SELECT
'{{ invocation_id }}' as invocation_id,
  *
FROM {{ source('btc', 'btc') }}

{% if is_incremental() %}
WHERE BLOCK_TIMESTAMP >= (
  SELECT max(BLOCK_TIMESTAMP)
  FROM {{ this }}
)
{% endif %}

