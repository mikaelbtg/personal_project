-- Memanggil dataset users dengan variabel yang akan digunakan dan mengubah tipe data kolom created_at menjadi date
SELECT 
	id, 
	age , 
	gender , 
	country , 
	traffic_source , 
	CAST(created_at AS date) AS date_created_at
FROM users u ;

-- Memanggil dataset events dengan variabel yang diinginkan dan mengubah tipe data kolom date menjadi date
SELECT 
	id , 
	user_id , 
	session_id , 
	CAST(created_at AS date) AS date_created_at , 
	browser , 
	traffic_source, 
	event_type 
FROM events e ;

/* Membuat dataset product view event yang menampilkan traffic dengan event type product dengan detail
 * produk yang dikunjungi dengan fungsi join pada dataset event dan product
 * 1. Membuat common table expression(CTE) untuk menyaring traffic event type product, mengubah 
 * tipe data kolom created_at menjadi date dan membuat kolom kode produk yang dikunjungi disatukan dengan variabel yang akan dipakai*/
WITH product_view_event AS 
( SELECT 
	id, 
	user_id , 
	session_id , 
	CAST(created_at AS date) AS date_created_at , 
	traffic_source , 
	CAST(RIGHT(uri,length(uri)-length('/product/')) AS integer) AS product_id
FROM events e 
WHERE event_type = 'product' 
)
/* 2. Gabungkan CTE tersebut dengan dataset product menggunakan inner join dengan product id sebagai key, 
 * lalu panggil variabel yang akan digunakan */
SELECT 
	pv.*, 
	p."name" AS product_name, 
	concat(p.department, '''s ', p.category) AS product_category, 
	p.brand AS product_brand
FROM product_view_event pv
INNER JOIN products p ON pv.product_id = p.id ;