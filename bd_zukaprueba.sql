-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 11-06-2023 a las 03:01:19
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bd_zukaprueba`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `efectuar_ingreso` (IN `ingid` BIGINT(20), IN `prodid` BIGINT(20), IN `cant` INT(11), IN `prec` DECIMAL(11,2))   begin
INSERT INTO detalle_ingreso(ingresoid,productoid,cantidad,precio) VALUES (ingid,prodid,cant,prec);
UPDATE producto SET stock = stock + cant WHERE idproducto = prodid;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `efectuar_pago` (IN `pedid` BIGINT(20), IN `prodid` BIGINT(20), IN `prec` DECIMAL(11,2), IN `cant` INT(11))   begin
INSERT INTO detalle_pedido (pedidoid,productoid,precio,cantidad) VALUES (pedid,prodid,prec,cant);
UPDATE almacen SET cantidad = cantidad - cant WHERE productoid = prodid;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Ingreso_stock` (IN `almid` BIGINT(20), IN `persid` VARCHAR(255), IN `cant` INT(11))   begin
INSERT INTO detalle_ingreso(almacenid,personaid,cantidad) 
VALUES (almid,persid,cant); 
UPDATE almacen SET cantidad = cantidad + cant WHERE id = almid;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registro_almacen` (IN `catgid` BIGINT(20), IN `provid` BIGINT(20), IN `marid` BIGINT(20), IN `cod` VARCHAR(30), IN `nombr` VARCHAR(255), IN `descp` TEXT, IN `prec` DECIMAL(11,2), IN `cant` INT(11), IN `rut` VARCHAR(255), IN `sts` INT(11), IN `part` VARCHAR(255), IN `und` VARCHAR(255), IN `fact` VARCHAR(255))   begin
INSERT INTO producto(categoriaid,proveedorid,marcaid,codigo,nombre,descripcion,precio,stock,ruta,status,part_number,unidad_medida,factor_conversion) 
VALUES (catgid,provid,marid,cod,nombr,descp,prec,cant,rut,sts,part,und,fact);
SELECT @var_name := @@identity;
INSERT INTO almacen (productoid,cantidad) VALUES (@var_name,cant);
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `almacen`
--

CREATE TABLE `almacen` (
  `id` bigint(20) NOT NULL,
  `productoid` bigint(20) NOT NULL,
  `cantidad` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `almacen`
--

INSERT INTO `almacen` (`id`, `productoid`, `cantidad`) VALUES
(27, 31, 50);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

CREATE TABLE `categoria` (
  `idcategoria` bigint(20) NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_swedish_ci NOT NULL,
  `portada` varchar(100) COLLATE utf8mb4_swedish_ci NOT NULL,
  `datecreated` datetime NOT NULL DEFAULT current_timestamp(),
  `ruta` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`idcategoria`, `nombre`, `descripcion`, `portada`, `datecreated`, `ruta`, `status`) VALUES
(1, 'Faros', 'Lo mejor', 'img_125e45445bd33723d025d7f815ca29f7.jpg', '2021-08-20 03:04:04', 'faros', 1),
(2, 'Aros', 'Lo mejor en tecnología', 'img_78678a3fe95890d155115d5301e0761d.jpg', '2021-08-21 00:47:10', 'aros', 1),
(3, 'Prueba12', 'ADS', 'portada_categoria.png', '2023-01-04 16:15:35', '', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_ingreso`
--

CREATE TABLE `detalle_ingreso` (
  `id` bigint(20) NOT NULL,
  `almacenid` bigint(20) NOT NULL,
  `personaid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_swedish_ci NOT NULL,
  `cantidad` int(20) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `detalle_ingreso`
--

INSERT INTO `detalle_ingreso` (`id`, `almacenid`, `personaid`, `cantidad`, `fecha`) VALUES
(10, 27, 'Eloy Herrera', 10, '2023-06-08 02:47:45'),
(11, 27, 'Eloy Herrera', 10, '2023-06-08 02:48:27');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_pedido`
--

CREATE TABLE `detalle_pedido` (
  `id` bigint(20) NOT NULL,
  `pedidoid` bigint(20) NOT NULL,
  `productoid` bigint(20) NOT NULL,
  `precio` decimal(11,2) NOT NULL,
  `cantidad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `detalle_pedido`
--

INSERT INTO `detalle_pedido` (`id`, `pedidoid`, `productoid`, `precio`, `cantidad`) VALUES
(29, 24, 11, '12.00', 2),
(30, 25, 13, '400.00', 2),
(31, 26, 13, '400.00', 2),
(32, 27, 16, '100.00', 2),
(33, 27, 15, '350.00', 2),
(34, 28, 15, '350.00', 1),
(35, 29, 31, '350.00', 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_temp`
--

CREATE TABLE `detalle_temp` (
  `id` bigint(20) NOT NULL,
  `personaid` bigint(20) NOT NULL,
  `productoid` bigint(20) NOT NULL,
  `precio` decimal(11,2) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `transaccionid` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `envio`
--

CREATE TABLE `envio` (
  `idenvio` bigint(20) NOT NULL,
  `pedidoid` bigint(20) NOT NULL,
  `fecha` datetime NOT NULL,
  `monto` decimal(11,2) NOT NULL,
  `tipopago` int(11) NOT NULL,
  `direccion` varchar(250) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `envio`
--

INSERT INTO `envio` (`idenvio`, `pedidoid`, `fecha`, `monto`, `tipopago`, `direccion`) VALUES
(1, 21, '0000-00-00 00:00:00', '0.00', 0, ''),
(2, 20, '0000-00-00 00:00:00', '0.00', 0, ''),
(3, 25, '0000-00-00 00:00:00', '0.00', 0, ''),
(4, 25, '0000-00-00 00:00:00', '0.00', 0, ''),
(5, 25, '0000-00-00 00:00:00', '0.00', 0, ''),
(6, 24, '0000-00-00 00:00:00', '0.00', 0, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `imagen`
--

CREATE TABLE `imagen` (
  `id` bigint(20) NOT NULL,
  `productoid` bigint(20) NOT NULL,
  `img` varchar(100) COLLATE utf8mb4_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `imagen`
--

INSERT INTO `imagen` (`id`, `productoid`, `img`) VALUES
(26, 13, 'pro_c1024eb3f4b62eccc2daaa8ef8e3e1a3.jpg'),
(27, 14, 'pro_3bfa37929751fe843e585d21864dc051.jpg'),
(29, 15, 'pro_83619e171d71be52ed6178edba84e73f.jpg'),
(30, 16, 'pro_0ed6706a59142ed82afdf77e61129626.jpg'),
(33, 31, 'pro_b5d1d3d449a2052418e34a0b8be71d10.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marca`
--

CREATE TABLE `marca` (
  `idmarca` bigint(20) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `marca`
--

INSERT INTO `marca` (`idmarca`, `nombre`, `descripcion`, `status`) VALUES
(1, 'itachi', 'Marca de repuestos de autos Japones', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulo`
--

CREATE TABLE `modulo` (
  `idmodulo` bigint(20) NOT NULL,
  `titulo` varchar(50) COLLATE utf8mb4_swedish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_swedish_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `modulo`
--

INSERT INTO `modulo` (`idmodulo`, `titulo`, `descripcion`, `status`) VALUES
(1, 'Dashboard', 'Dashboard', 1),
(2, 'Usuarios', 'Usuarios del sistema', 1),
(3, 'Clientes', 'Clientes de tienda', 1),
(4, 'Productos', 'Todos los productos', 1),
(5, 'Pedidos', 'Pedidos', 1),
(6, 'Caterogías', 'Caterogías Productos', 1),
(7, 'Suscriptores', 'Suscriptores del sitio web', 1),
(8, 'Contactos', 'Mensajes del formulario contacto', 1),
(9, 'Páginas', 'Páginas del sitio web', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `idpedido` bigint(20) NOT NULL,
  `referenciacobro` varchar(255) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `idtransaccionpaypal` varchar(255) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `datospaypal` text COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `personaid` bigint(20) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  `costo_envio` decimal(10,2) NOT NULL DEFAULT 0.00,
  `monto` decimal(11,2) NOT NULL,
  `tipopagoid` bigint(20) NOT NULL,
  `direccion_envio` text COLLATE utf8mb4_swedish_ci NOT NULL,
  `status` varchar(100) COLLATE utf8mb4_swedish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `pedido`
--

INSERT INTO `pedido` (`idpedido`, `referenciacobro`, `idtransaccionpaypal`, `datospaypal`, `personaid`, `fecha`, `costo_envio`, `monto`, `tipopagoid`, `direccion_envio`, `status`) VALUES
(3, NULL, NULL, NULL, 1, '2022-11-13 02:19:17', '5.00', '605.00', 5, 'Prueba, Prueba', 'Pendiente'),
(4, NULL, NULL, NULL, 1, '2022-11-13 02:21:24', '5.00', '605.00', 3, 'prueba, prueba', 'Pendiente'),
(5, NULL, NULL, NULL, 1, '2022-11-13 02:23:11', '5.00', '605.00', 4, 'prueba, prueba', 'Pendiente'),
(6, NULL, NULL, NULL, 1, '2022-11-13 10:58:38', '5.00', '25.00', 2, 'prueba, prueba', 'Pendiente'),
(7, NULL, NULL, NULL, 1, '2022-11-13 12:53:07', '5.00', '605.00', 2, ', ', 'Pendiente'),
(8, NULL, NULL, NULL, 1, '2022-11-13 12:54:24', '5.00', '405.00', 2, 'prueba, preba', 'Pendiente'),
(9, '12', NULL, NULL, 5, '2022-11-13 19:21:11', '5.00', '45.00', 3, 'd, d', 'Completo'),
(10, NULL, '43662093AG704403X', '{\"id\":\"4YV71763HM897444W\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"45.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Tienda Virtual por S/45 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"43662093AG704403X\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"45.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2022-11-21T15:32:01Z\",\"update_time\":\"2022-11-21T15:32:01Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2022-11-21T15:31:35Z\",\"update_time\":\"2022-11-21T15:32:01Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/4YV71763HM897444W\",\"rel\":\"self\",\"method\":\"GET\"}]}', 5, '2022-11-21 10:32:02', '5.00', '45.00', 1, 'lino, lino', 'Completo'),
(11, NULL, '8L486969G4843353G', '{\"id\":\"2DD57395WT1794100\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"65.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Tienda Virtual por S/65 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"8L486969G4843353G\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"65.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2022-11-21T15:35:36Z\",\"update_time\":\"2022-11-21T15:35:36Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2022-11-21T15:35:29Z\",\"update_time\":\"2022-11-21T15:35:36Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/2DD57395WT1794100\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2022-11-21 10:35:36', '5.00', '65.00', 1, 'lino, lino', 'Completo'),
(12, NULL, NULL, NULL, 1, '2022-11-21 10:37:20', '5.00', '905.00', 2, 'lino, lino', 'Pendiente'),
(13, NULL, '59P75038HH610273L', '{\"id\":\"9TK89989WT465141D\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"4005.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka SAC por S/4005 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"59P75038HH610273L\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"4005.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2022-11-30T21:57:13Z\",\"update_time\":\"2022-11-30T21:57:13Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2022-11-30T21:56:59Z\",\"update_time\":\"2022-11-30T21:57:13Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/9TK89989WT465141D\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2022-11-30 16:57:13', '5.00', '4005.00', 1, 'lima, lima', 'Aprobado'),
(14, NULL, NULL, NULL, 1, '2022-11-30 16:58:39', '5.00', '20005.00', 2, 'lima, lima', 'Pendiente'),
(15, NULL, '4WT34182GX521462V', '{\"id\":\"3YT01378FU614154Y\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"17.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka SAC por S/17 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"4WT34182GX521462V\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"17.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-02-07T02:25:51Z\",\"update_time\":\"2023-02-07T02:25:51Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-02-07T02:25:32Z\",\"update_time\":\"2023-02-07T02:25:51Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/3YT01378FU614154Y\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-02-06 21:25:51', '5.00', '17.00', 1, 'lol, lol', 'Completo'),
(16, NULL, '75C0645291153210C', '{\"id\":\"4JM12370MH252661M\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"29.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka SAC por S/29 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"75C0645291153210C\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"29.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-02-09T01:10:31Z\",\"update_time\":\"2023-02-09T01:10:31Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-02-09T01:10:01Z\",\"update_time\":\"2023-02-09T01:10:31Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/4JM12370MH252661M\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-02-08 20:10:30', '5.00', '29.00', 1, 'lol, lol', 'Completo'),
(17, NULL, NULL, NULL, 1, '2023-02-08 20:18:41', '5.00', '65.00', 2, 'artic, artic', 'Pendiente'),
(18, NULL, '0NA03783BP425231C', '{\"id\":\"44757899N0366091R\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"29.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka SAC por S/29 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"0NA03783BP425231C\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"29.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-02-09T04:54:06Z\",\"update_time\":\"2023-02-09T04:54:06Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-02-09T04:51:35Z\",\"update_time\":\"2023-02-09T04:54:06Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/44757899N0366091R\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-02-08 23:54:05', '5.00', '29.00', 1, 'lol, lol', 'Completo'),
(19, NULL, NULL, NULL, 1, '2023-02-10 19:44:03', '5.00', '65.00', 2, 'lol, lol', 'Pendiente'),
(20, NULL, '4ME13020LA677972S', '{\"id\":\"5KA39710DN8530409\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"29.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka SAC por S/29 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"4ME13020LA677972S\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"29.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-02-16T00:19:06Z\",\"update_time\":\"2023-02-16T00:19:06Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-02-16T00:13:09Z\",\"update_time\":\"2023-02-16T00:19:06Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/5KA39710DN8530409\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-02-15 19:19:05', '5.00', '29.00', 1, 'ddd, ddd', 'Completo'),
(21, 'dos', NULL, NULL, 1, '2023-02-15 19:20:13', '5.00', '17.00', 2, 'sds, sdsd', 'Aprobado'),
(22, NULL, NULL, NULL, 1, '2023-04-02 19:27:57', '5.00', '29.00', 2, 'Prueba, Prueba', 'Pendiente'),
(23, NULL, '8NA87895M4873352X', '{\"id\":\"8MG95605KH032071X\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"17.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka Imports por S/17 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"8NA87895M4873352X\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"17.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-04-07T01:20:43Z\",\"update_time\":\"2023-04-07T01:20:43Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-04-07T01:20:27Z\",\"update_time\":\"2023-04-07T01:20:43Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/8MG95605KH032071X\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-04-06 20:20:44', '5.00', '17.00', 1, 'lol, lol', 'Completo'),
(24, NULL, '7NE00072VC758163M', '{\"id\":\"4ER6986282335223H\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"29.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka Imports por S/29 \",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"7NE00072VC758163M\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"29.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-04-07T06:26:29Z\",\"update_time\":\"2023-04-07T06:26:29Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-04-07T06:26:17Z\",\"update_time\":\"2023-04-07T06:26:29Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/4ER6986282335223H\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-04-07 01:26:30', '5.00', '29.00', 1, 'lol, lol', 'Completo'),
(25, NULL, '9BR5288615387183V', '{\"id\":\"6JB06060RG123750C\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"805.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka Imports por S/805 \",\"soft_descriptor\":\"PAYPAL *TEST STORE\",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"9BR5288615387183V\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"805.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-04-07T16:32:54Z\",\"update_time\":\"2023-04-07T16:32:54Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-04-07T16:32:20Z\",\"update_time\":\"2023-04-07T16:32:54Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/6JB06060RG123750C\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-04-07 11:32:53', '5.00', '805.00', 1, 'Av VMT, Av VMT', 'Completo'),
(26, NULL, '0FL76670W52518258', '{\"id\":\"1B333146K4330924N\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"805.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka Imports por S/805 \",\"soft_descriptor\":\"PAYPAL *TEST STORE\",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"0FL76670W52518258\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"805.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-04-23T23:59:59Z\",\"update_time\":\"2023-04-23T23:59:59Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-04-23T23:55:08Z\",\"update_time\":\"2023-04-23T23:59:59Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/1B333146K4330924N\",\"rel\":\"self\",\"method\":\"GET\"}]}', 6, '2023-04-23 19:00:00', '5.00', '805.00', 1, 'lol, lol', 'Completo'),
(27, NULL, NULL, NULL, 1, '2023-05-21 18:49:23', '5.00', '905.00', 2, 'av tacna, av tacna', 'Pendiente'),
(28, NULL, '88989285VE403804N', '{\"id\":\"8UV56713913042717\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"355.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka Imports por S/355 \",\"soft_descriptor\":\"PAYPAL *TEST STORE\",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"88989285VE403804N\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"355.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-06-08T07:58:06Z\",\"update_time\":\"2023-06-08T07:58:06Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-06-08T07:57:23Z\",\"update_time\":\"2023-06-08T07:58:06Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/8UV56713913042717\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-06-08 02:58:05', '5.00', '355.00', 1, 'Av Benavides, Lima', 'Completo'),
(29, NULL, '5J038951VE879840K', '{\"id\":\"67E44788AJ809050E\",\"intent\":\"CAPTURE\",\"status\":\"COMPLETED\",\"purchase_units\":[{\"reference_id\":\"default\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"3505.00\"},\"payee\":{\"email_address\":\"sb-lihkg22262342@business.example.com\",\"merchant_id\":\"JYMYLNKT43E62\"},\"description\":\"Compra de artículos en Zuka Imports por S/3505 \",\"soft_descriptor\":\"PAYPAL *TEST STORE\",\"shipping\":{\"name\":{\"full_name\":\"John Doe\"},\"address\":{\"address_line_1\":\"Free Trade Zone\",\"admin_area_2\":\"Lima\",\"admin_area_1\":\"Lima\",\"postal_code\":\"07001\",\"country_code\":\"PE\"}},\"payments\":{\"captures\":[{\"id\":\"5J038951VE879840K\",\"status\":\"COMPLETED\",\"amount\":{\"currency_code\":\"USD\",\"value\":\"3505.00\"},\"final_capture\":true,\"seller_protection\":{\"status\":\"ELIGIBLE\",\"dispute_categories\":[\"ITEM_NOT_RECEIVED\",\"UNAUTHORIZED_TRANSACTION\"]},\"create_time\":\"2023-06-08T07:59:46Z\",\"update_time\":\"2023-06-08T07:59:46Z\"}]}}],\"payer\":{\"name\":{\"given_name\":\"John\",\"surname\":\"Doe\"},\"email_address\":\"sb-tnggw22263091@personal.example.com\",\"payer_id\":\"H4BSXVLHKG8Z2\",\"address\":{\"country_code\":\"PE\"}},\"create_time\":\"2023-06-08T07:59:37Z\",\"update_time\":\"2023-06-08T07:59:46Z\",\"links\":[{\"href\":\"https://api.sandbox.paypal.com/v2/checkout/orders/67E44788AJ809050E\",\"rel\":\"self\",\"method\":\"GET\"}]}', 1, '2023-06-08 02:59:45', '5.00', '3505.00', 1, 'Av Benavides, Av Benavides', 'Aprobado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permisos`
--

CREATE TABLE `permisos` (
  `idpermiso` bigint(20) NOT NULL,
  `rolid` bigint(20) NOT NULL,
  `moduloid` bigint(20) NOT NULL,
  `r` int(11) NOT NULL DEFAULT 0,
  `w` int(11) NOT NULL DEFAULT 0,
  `u` int(11) NOT NULL DEFAULT 0,
  `d` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `permisos`
--

INSERT INTO `permisos` (`idpermiso`, `rolid`, `moduloid`, `r`, `w`, `u`, `d`) VALUES
(12, 2, 1, 1, 1, 1, 1),
(13, 2, 2, 0, 0, 0, 0),
(14, 2, 3, 1, 1, 1, 0),
(15, 2, 4, 1, 1, 1, 0),
(16, 2, 5, 1, 1, 1, 0),
(17, 2, 6, 1, 1, 1, 0),
(18, 2, 7, 1, 0, 0, 0),
(19, 2, 8, 1, 0, 0, 0),
(20, 2, 9, 1, 1, 1, 1),
(21, 3, 1, 0, 0, 0, 0),
(22, 3, 2, 0, 0, 0, 0),
(23, 3, 3, 0, 0, 0, 0),
(24, 3, 4, 0, 0, 0, 0),
(25, 3, 5, 1, 0, 0, 0),
(26, 3, 6, 0, 0, 0, 0),
(27, 3, 7, 0, 0, 0, 0),
(28, 3, 8, 0, 0, 0, 0),
(29, 3, 9, 0, 0, 0, 0),
(30, 4, 1, 1, 0, 0, 0),
(31, 4, 2, 0, 0, 0, 0),
(32, 4, 3, 1, 1, 1, 0),
(33, 4, 4, 1, 0, 0, 0),
(34, 4, 5, 1, 0, 1, 0),
(35, 4, 6, 0, 0, 0, 0),
(36, 4, 7, 1, 0, 0, 0),
(37, 4, 8, 1, 0, 0, 0),
(38, 4, 9, 0, 0, 0, 0),
(39, 1, 1, 1, 1, 1, 1),
(40, 1, 2, 1, 1, 1, 1),
(41, 1, 3, 1, 1, 1, 1),
(42, 1, 4, 1, 1, 1, 1),
(43, 1, 5, 1, 1, 1, 1),
(44, 1, 6, 1, 1, 1, 1),
(45, 1, 7, 1, 1, 1, 1),
(46, 1, 8, 1, 1, 1, 1),
(47, 1, 9, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `idpersona` bigint(20) NOT NULL,
  `identificacion` varchar(30) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `nombres` varchar(80) COLLATE utf8mb4_swedish_ci NOT NULL,
  `apellidos` varchar(100) COLLATE utf8mb4_swedish_ci NOT NULL,
  `telefono` bigint(20) NOT NULL,
  `email_user` varchar(100) COLLATE utf8mb4_swedish_ci NOT NULL,
  `password` varchar(75) COLLATE utf8mb4_swedish_ci NOT NULL,
  `nit` varchar(20) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `nombrefiscal` varchar(80) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `direccionfiscal` varchar(100) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `token` varchar(100) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `rolid` bigint(20) NOT NULL,
  `datecreated` datetime NOT NULL DEFAULT current_timestamp(),
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`idpersona`, `identificacion`, `nombres`, `apellidos`, `telefono`, `email_user`, `password`, `nit`, `nombrefiscal`, `direccionfiscal`, `token`, `rolid`, `datecreated`, `status`) VALUES
(1, '24091989', 'Eloy', 'Herrera', 123456, 'admin@zuka.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'CF', 'EloyRoberto', 'Lima', NULL, 1, '2021-08-20 01:34:15', 1),
(2, '24091990', 'Kenji', 'Km', 456878977, 'km@zuka.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', NULL, 'HP', 'Lima', NULL, 2, '2021-08-20 02:58:47', 1),
(3, '84654864', 'Brenda', 'Correa', 4687987, 'bc@zuka.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', '468798', 'ZK', 'Lima', NULL, 3, '2021-08-20 03:41:28', 0),
(4, '798465877', 'Camila', 'Sumaran', 468498, 'cs@zuka.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', NULL, NULL, NULL, NULL, 4, '2021-08-21 18:07:00', 1),
(5, '20202020', 'Prueba', 'Prueba', 987654456, 'prueba@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', '12', '12', '12', '8373125cb8016cf667a5-dd4485ff7ec55f346dc6-705556d34047c5d7db21-b06de44dd7a5c6e8a63a', 3, '2022-11-13 02:07:06', 2),
(6, '202011', 'Obara', 'Yoshikawa', 984342273, 'obara@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', '202011', 'Lima', 'Lima', NULL, 3, '2023-04-23 18:54:54', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `post`
--

CREATE TABLE `post` (
  `idpost` bigint(20) NOT NULL,
  `titulo` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL,
  `contenido` text COLLATE utf8mb4_swedish_ci NOT NULL,
  `portada` varchar(100) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `datecreate` datetime NOT NULL DEFAULT current_timestamp(),
  `ruta` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `post`
--

INSERT INTO `post` (`idpost`, `titulo`, `contenido`, `portada`, `datecreate`, `ruta`, `status`) VALUES
(1, 'Inicio', '<div class=\"p-t-80\"> <h3 class=\"ltext-103 cl5\">Nuestras marcas</h3> </div> <div> <p>Trabajamos con las mejores marcas del mundo ...</p> </div> <div class=\"row\"> <div class=\"col-md-3\"><img src=\"Assets/images/m1.png\" alt=\"Marca 1\" width=\"110\" height=\"110\" /></div> <div class=\"col-md-3\"><img src=\"Assets/images/m2.png\" alt=\"Marca 2\" /></div> <div class=\"col-md-3\"><img src=\"Assets/images/m3.png\" alt=\"Marca 3\" /></div> <div class=\"col-md-3\"><img src=\"Assets/images/m4.png\" alt=\"Marca 4\" /></div> </div>', '', '2021-07-20 02:40:15', 'inicio', 1),
(2, 'Tienda', '<p>Contenido p&aacute;gina!</p>', '', '2021-08-06 01:21:27', 'tienda', 1),
(3, 'Carrito', '<p>Contenido p&aacute;gina!</p>', '', '2021-08-06 01:21:52', 'carrito', 1),
(4, 'Nosotros', '<section class=\"bg0 p-t-75 p-b-120\"> <div class=\"container\"> <div class=\"row p-b-148\"> <div class=\"col-md-7 col-lg-8\"> <div class=\"p-t-7 p-r-85 p-r-15-lg p-r-0-md\"> <h3 class=\"mtext-111 cl2 p-b-16\">Historia</h3> <p class=\"stext-113 cl6 p-b-26\">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris consequat consequat enim, non auctor massa ultrices non. Morbi sed odio massa. Quisque at vehicula tellus, sed tincidunt augue. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Maecenas varius egestas diam, eu sodales metus scelerisque congue. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Maecenas gravida justo eu arcu egestas convallis. Nullam eu erat bibendum, tempus ipsum eget, dictum enim. Donec non neque ut enim dapibus tincidunt vitae nec augue. Suspendisse potenti. Proin ut est diam. Donec condimentum euismod tortor, eget facilisis diam faucibus et. Morbi a tempor elit.</p> <p class=\"stext-113 cl6 p-b-26\">Donec gravida lorem elit, quis condimentum ex semper sit amet. Fusce eget ligula magna. Aliquam aliquam imperdiet sodales. Ut fringilla turpis in vehicula vehicula. Pellentesque congue ac orci ut gravida. Aliquam erat volutpat. Donec iaculis lectus a arcu facilisis, eu sodales lectus sagittis. Etiam pellentesque, magna vel dictum rutrum, neque justo eleifend elit, vel tincidunt erat arcu ut sem. Sed rutrum, turpis ut commodo efficitur, quam velit convallis ipsum, et maximus enim ligula ac ligula.</p> <p class=\"stext-113 cl6 p-b-26\">Any questions? Let us know in store at 8th floor, 379 Hudson St, New York, NY 10018 or call us on (+1) 96 716 6879</p> </div> </div> <div class=\"col-11 col-md-5 col-lg-4 m-lr-auto\"> <div class=\"how-bor1 \"> <div class=\"hov-img0\"><img src=\"https://cdn.pixabay.com/photo/2015/07/17/22/43/student-849825_1280.jpg\" alt=\"IMG\" width=\"500\" height=\"333\" /></div> </div> </div> </div> <div class=\"row\"> <div class=\"order-md-2 col-md-7 col-lg-8 p-b-30\"> <div class=\"p-t-7 p-l-85 p-l-15-lg p-l-0-md\"> <h2 class=\"mtext-111 cl2 p-b-16\"><span style=\"color: #236fa1;\">Nuestra Misi&oacute;n</span></h2> <p class=\"stext-113 cl6 p-b-26\">Mauris non lacinia magna. Sed nec lobortis dolor. Vestibulum rhoncus dignissim risus, sed consectetur erat. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Nullam maximus mauris sit amet odio convallis, in pharetra magna gravida. Praesent sed nunc fermentum mi molestie tempor. Morbi vitae viverra odio. Pellentesque ac velit egestas, luctus arcu non, laoreet mauris. Sed in ipsum tempor, consequat odio in, porttitor ante. Ut mauris ligula, volutpat in sodales in, porta non odio. Pellentesque tempor urna vitae mi vestibulum, nec venenatis nulla lobortis. Proin at gravida ante. Mauris auctor purus at lacus maximus euismod. Pellentesque vulputate massa ut nisl hendrerit, eget elementum libero iaculis.</p> <div class=\"bor16 p-l-29 p-b-9 m-t-22\"> <p class=\"stext-114 cl6 p-r-40 p-b-11\">Creativity is just connecting things. When you ask creative people how they did something, they feel a little guilty because they didn\'t really do it, they just saw something. It seemed obvious to them after a while.</p> <span class=\"stext-111 cl8\"> - Steve Job&rsquo;s </span></div> </div> </div> <div class=\"order-md-1 col-11 col-md-5 col-lg-4 m-lr-auto p-b-30\"> <div class=\"how-bor2\"> <div class=\"hov-img0\"><img src=\"https://cdn.pixabay.com/photo/2015/07/17/22/43/student-849822_1280.jpg\" alt=\"IMG\" width=\"500\" height=\"333\" /></div> </div> </div> </div> </div> </section>', 'img_2f644b056a9fd3624c7595d24b1d9273.jpg', '2021-08-09 03:09:44', 'nosotros', 1),
(5, 'Contacto', '<div class=\"map\"><iframe style=\"border: 0;\" src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3861.685802352331!2d-90.73646108521129!3d14.559951589828378!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x85890e74b3771e19%3A0x68ec9eeea79fd9a7!2sEl%20Arco%20de%20Santa%20Catalina!5e0!3m2!1ses!2sgt!4v1624005005655!5m2!1ses!2sgt\" width=\"100%\" height=\"600\" allowfullscreen=\"allowfullscreen\" loading=\"lazy\"></iframe></div>', 'img_3024f13dc010ffab8c22da05ac6a32b9.jpg', '2021-08-09 03:11:08', 'contacto', 1),
(6, 'Preguntas frecuentes', '<ol> <li><strong>&iquest;Cu&aacute;l es el tiempo de entrega de los producto? </strong>Lorem ipsum dolor sit amet consectetur adipisicing elit. Nobis sunt, corrupti hic aspernatur cumque alias, ipsam omnis iure ipsum, nostrum labore obcaecati natus repellendus consequatur est nemo sapiente dolorem dicta. Lorem, ipsum dolor sit amet consectetur adipisicing elit. Commodi, voluptas, consectetur iusto delectus quaerat ullam nesciunt! Quae doloribus deserunt qui fugit illo nobis ipsum, accusamus eius perferendis beatae culpa molestias!</li> <li><strong>&iquest;C&oacute;mo es la forma de env&iacute;o de los productos?</strong> Lorem ipsum dolor sit amet consectetur adipisicing elit. Nobis sunt, corrupti hic aspernatur cumque alias, ipsam omnis iure ipsum, nostrum labore obcaecati natus repellendus consequatur est nemo sapiente dolorem dicta. Lorem, ipsum dolor sit amet consectetur adipisicing elit. Commodi, voluptas, consectetur.</li></ol> <p>&nbsp;</p> <p>Otras preguntas</p> <ul> <li><strong>&iquest;Qu&eacute; formas de pago aceptan? </strong><span style=\"color: #666666; font-family: Arial, sans-serif; font-size: 15px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: left; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">Corrupti hic aspernatur cumque alias, ipsam omnis iure ipsum, nostrum labore obcaecati natus repellendus consequatur est nemo sapiente dolorem dicta. Lorem, ipsum dolor sit amet consectetur adipisicing elit. Commodi, voluptas, consectetur iusto delectus quaerat ullam nesciunt! Quae doloribus deserunt qui fugit illo nobis ipsum, accusamus eius perferendis</span></li> </ul>', '', '2021-08-11 01:24:19', 'preguntas-frecuentes', 1),
(7, 'Términos y Condiciones', '<p>A continuaci&oacute;n se describen los t&eacute;rmino y condiciones de la Tienda Virtual!</p> <ol> <li>Pol&iacute;tica uno</li> <li>Termino dos</li> <li>Condici&oacute;n tres</li> </ol> <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Nobis sunt, corrupti hic aspernatur cumque alias, ipsam omnis iure ipsum, nostrum labore obcaecati natus repellendus consequatur est nemo sapiente dolorem dicta. Lorem, ipsum dolor sit amet consectetur adipisicing elit. Commodi, voluptas, consectetur iusto delectus quaerat ullam nesciunt! Quae doloribus deserunt qui fugit illo nobis ipsum, accusamus eius perferendis beatae culpa molestias!</p>', '', '2021-08-11 01:51:06', 'terminos-y-condiciones', 1),
(8, 'Sucursales', '<section class=\"py-5 text-center\"> <div class=\"container\"> <p>Visitanos y obten los mejores precios del mercado, cualquier art&iacute;culo que necestas para vivir mejor</p> <a class=\"btn btn-info\" href=\"../../tienda_virtual/tienda\">VER PRODUCTOS</a></div> </section> <div class=\"py-5 bg-light\"> <div class=\"container\"> <div class=\"row\"> <div class=\"col-md-4\"> <div class=\"card mb-4 box-shadow hov-img0\"><img src=\"https://abelosh.com/tienda_virtual/Assets/images/s1.jpg\" alt=\"Tienda Uno\" width=\"100%\" height=\"100%\" /> <div class=\"card-body\"> <p class=\"card-text\">Lorem ipsum dolor, sit amet consectetur adipisicing elit. Quaerat necessitatibus eligendi, soluta ipsa natus, at earum qui enim, illum doloremque, accusantium autem nemo est esse nulla neque eaque repellendus amet.</p> <p>Direcci&oacute;n: Antigua Gautemala <br />Tel&eacute;fono: 4654645 <br />Correo: info@abelosh.com</p> </div> </div> </div> <div class=\"col-md-4\"> <div class=\"card mb-4 box-shadow hov-img0\"><img src=\"https://abelosh.com/tienda_virtual/Assets/images/s2.jpg\" alt=\"Sucural dos\" width=\"100%\" height=\"100%\" /> <div class=\"card-body\"> <p class=\"card-text\">Lorem ipsum dolor, sit amet consectetur adipisicing elit. Quaerat necessitatibus eligendi, soluta ipsa natus, at earum qui enim, illum doloremque, accusantium autem nemo est esse nulla neque eaque repellendus amet.</p> <p>Direcci&oacute;n: Antigua Gautemala <br />Tel&eacute;fono: 4654645 <br />Correo: info@abelosh.com</p> </div> </div> </div> <div class=\"col-md-4\"> <div class=\"card mb-4 box-shadow hov-img0\"><img src=\"https://abelosh.com/tienda_virtual/Assets/images/s3.jpg\" alt=\"Sucural tres\" width=\"100%\" height=\"100%\" /> <div class=\"card-body\"> <p class=\"card-text\">Lorem ipsum dolor, sit amet consectetur adipisicing elit. Quaerat necessitatibus eligendi, soluta ipsa natus, at earum qui enim, illum doloremque, accusantium autem nemo est esse nulla neque eaque repellendus amet.</p> <p>Direcci&oacute;n: Antigua Gautemala <br />Tel&eacute;fono: 4654645 <br />Correo: info@abelosh.com</p> </div> </div> </div> </div> </div> </div>', 'img_d72cb5712933863e051dc9c7fac5e253.jpg', '2021-08-11 02:26:45', 'sucursales', 1),
(9, 'Not Found', '<h1>Error 404: P&aacute;gina no encontrada</h1> <p>No se encuentra la p&aacute;gina que ha solicitado.</p>', '', '2021-08-12 02:30:49', 'not-found', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idproducto` bigint(20) NOT NULL,
  `categoriaid` bigint(20) NOT NULL,
  `proveedorid` bigint(20) NOT NULL,
  `marcaid` bigint(20) NOT NULL,
  `codigo` varchar(30) COLLATE utf8mb4_swedish_ci NOT NULL,
  `nombre` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_swedish_ci NOT NULL,
  `precio` decimal(11,2) NOT NULL,
  `stock` int(11) NOT NULL,
  `imagen` varchar(100) COLLATE utf8mb4_swedish_ci DEFAULT NULL,
  `datecreated` datetime NOT NULL DEFAULT current_timestamp(),
  `ruta` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `part_number` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL,
  `unidad_medida` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL,
  `factor_conversion` varchar(255) COLLATE utf8mb4_swedish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idproducto`, `categoriaid`, `proveedorid`, `marcaid`, `codigo`, `nombre`, `descripcion`, `precio`, `stock`, `imagen`, `datecreated`, `ruta`, `status`, `part_number`, `unidad_medida`, `factor_conversion`) VALUES
(1, 1, 14, 1, '2417984565', 'Bocinas bosh', '<p><strong style=\"margin: 0px; padding: 0px; color: #000000; font-family: \'Open Sans\', Arial, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: justify; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">Lorem Ipsum</strong><span style=\"color: #000000; font-family: \'Open Sans\', Arial, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: justify; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</span></p>', '100.00', 50, NULL, '2021-08-20 03:12:14', 'chaqueta-azul', 0, '', '', ''),
(2, 1, 14, 1, '456879878', 'Cola tiburon', '<p><strong style=\"margin: 0px; padding: 0px; color: #000000; font-family: \'Open Sans\', Arial, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; letter-spacing: normal; orphans: 2; text-align: justify; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;\">Lorem Ipsum</strong><span style=\"color: #000000; font-family: \'Open Sans\', Arial, sans-serif; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: justify; text-indent: 0px; text-transform: none; white-space: normal; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; background-color: #ffffff; text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;\">&nbsp;is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</span></p>', '200.00', 100, NULL, '2021-08-20 03:14:10', 'reloj', 0, '', '', ''),
(3, 2, 14, 1, '4658798787', 'Luces Led', '<p>Wireless Bluetooth streaming. 24 hours of playtime. IPX7 waterproof. JBL Connect plus. High-capacity battery. Connector type: 3.5 millimeter stereo. Power Source Type: Battery Powered.</p>', '300.00', 100, NULL, '2021-08-21 00:48:21', 'bocina-jbl-flip-5', 0, '', '', ''),
(4, 2, 14, 1, '10101', 'Foco', '<p>Prueba de un producto</p>', '20.00', 8, NULL, '2022-11-13 10:55:48', 'foco', 0, '', '', ''),
(5, 2, 14, 1, '123423', 'Timon', '', '12.00', 12, NULL, '2022-11-13 18:46:44', 'timon', 0, '', '', ''),
(6, 2, 14, 1, '123454443', 'poooooooou', '<p>pruebassss</p>', '12.00', 12, NULL, '2022-11-16 10:01:01', 'poooooooou', 0, '', '', ''),
(7, 2, 14, 1, '121212', 'Aros', '<p>Aros para autos deportivos ultimo modelo ja!</p>', '2000.00', 40, NULL, '2022-11-29 23:13:34', 'aros', 2, '', '', ''),
(8, 1, 14, 1, '123456', 'Pruebas123', '<p>Pruebas1</p> <p>-doan</p>', '12.00', 22, NULL, '2023-01-05 00:40:06', 'pruebas123', 2, '', '', ''),
(9, 1, 14, 1, '123453', 'prueba201', '<p>Pruebas</p>', '12.00', 12, NULL, '2023-01-05 01:19:18', 'prueba201', 2, '', '', ''),
(10, 1, 14, 1, '12343', 'Pruebas 2020', '<p>Pruebas 2020</p>', '12.00', 12, NULL, '2023-01-06 23:07:31', 'pruebas-2020', 2, '', '', ''),
(11, 1, 14, 1, '123134', 'Twingo', '<p>Pruebas</p>', '12.00', 45, NULL, '2023-01-16 21:11:45', 'twingo', 2, '', '', ''),
(12, 1, 14, 1, '123312', 'pruebas', '', '12.00', 12, NULL, '2023-01-22 20:41:27', 'pruebas', 2, '', '', ''),
(13, 1, 14, 1, '25252525', 'Obturador Kia', '<p>Obturador Kia</p> <ul> <li>Filtra Gasolina</li> <li>Mejor rendimiento</li> </ul>', '400.00', 66, NULL, '2023-04-07 11:31:03', 'obturador-kia', 1, '35100-2B150', 'UNIDAD', '1 uni'),
(14, 2, 14, 1, '15151617', 'Amortiguador Kia Picanto', '<p>Suspensores de LLanta Posteriores para Kia Picanto</p> <p>marca: Hitachi</p> <p>Modelo: Kia Picanto 2018</p> <p>Procedencia: Japones</p>', '450.00', 50, NULL, '2023-05-06 17:24:57', 'amortiguador-kia-picanto', 1, '55311-3R020', 'PAR', '2 uni'),
(15, 1, 14, 1, '2876715', 'Bomba Gasolina Impreza XI', '<p>Boba de Gasolina</p> <p>Marca: Itachi</p> <p>Procedencia: Japonesa</p> <p>Auto: Subaru Impreza 2008</p>', '350.00', 18, NULL, '2023-05-07 23:34:08', 'bomba-gasolina-impreza-xi', 1, '‎31110-25000', 'UNIDAD', '1 uni'),
(16, 1, 14, 1, '10101524', 'Sensor Temperatura Subaru Forester', '<p>Sensor de Temperatura Subaru Forester 2006-2008</p> <p>Modelo: Subaru Forester</p> <p>A&ntilde;o: 2006-2008</p> <p>Procedencia: Japones</p>', '100.00', 48, NULL, '2023-05-08 13:16:12', 'sensor-temperatura-subaru-forester', 1, '22630AA161', 'UNIDAD', '1 uni'),
(31, 1, 14, 1, '1000012', 'Radiador Honda', '<p>Radiador Honda</p>', '350.00', 40, NULL, '2023-06-08 02:46:39', 'radiador-honda', 1, '1000012HBK', 'UNI', '1');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedor`
--

CREATE TABLE `proveedor` (
  `idproveedor` bigint(20) NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_swedish_ci NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `email` varchar(50) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `proveedor`
--

INSERT INTO `proveedor` (`idproveedor`, `nombre`, `descripcion`, `email`, `status`) VALUES
(14, 'Kawahara Group', 'Proveedor Japones', 'Kawahara@yahoo.com', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idrol` bigint(20) NOT NULL,
  `nombrerol` varchar(50) COLLATE utf8mb4_swedish_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_swedish_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idrol`, `nombrerol`, `descripcion`, `status`) VALUES
(1, 'Administrador', 'Acceso a todo el sistema', 1),
(2, 'Supervisor', 'Supervisor de tiendas', 1),
(3, 'Cliente', 'Clientes en general', 1),
(4, 'Vendedor', 'Operador de tienda', 1),
(7, 'admin2023', 'admin2023', 1),
(8, 'prueba1234', 'prueba123', 0),
(9, 'Lol', 'Lol', 0),
(10, 'aver2', 'aver', 0),
(11, 'aver1', 'lol', 0),
(12, 'admin2', '2', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipopago`
--

CREATE TABLE `tipopago` (
  `idtipopago` bigint(20) NOT NULL,
  `tipopago` varchar(100) COLLATE utf8mb4_swedish_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_swedish_ci;

--
-- Volcado de datos para la tabla `tipopago`
--

INSERT INTO `tipopago` (`idtipopago`, `tipopago`, `status`) VALUES
(1, 'PayPal', 1),
(2, 'Efectivo', 1),
(3, 'Tarjeta', 1),
(4, 'Cheque', 1),
(5, 'Despósito Bancario', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productoid` (`productoid`);

--
-- Indices de la tabla `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`idcategoria`);

--
-- Indices de la tabla `detalle_ingreso`
--
ALTER TABLE `detalle_ingreso`
  ADD PRIMARY KEY (`id`),
  ADD KEY `almacenid` (`almacenid`);

--
-- Indices de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pedidoid` (`pedidoid`),
  ADD KEY `productoid` (`productoid`);

--
-- Indices de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productoid` (`productoid`),
  ADD KEY `personaid` (`personaid`);

--
-- Indices de la tabla `envio`
--
ALTER TABLE `envio`
  ADD PRIMARY KEY (`idenvio`),
  ADD KEY `pedidoid` (`pedidoid`);

--
-- Indices de la tabla `imagen`
--
ALTER TABLE `imagen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productoid` (`productoid`);

--
-- Indices de la tabla `marca`
--
ALTER TABLE `marca`
  ADD PRIMARY KEY (`idmarca`);

--
-- Indices de la tabla `modulo`
--
ALTER TABLE `modulo`
  ADD PRIMARY KEY (`idmodulo`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`idpedido`),
  ADD KEY `personaid` (`personaid`),
  ADD KEY `tipopagoid` (`tipopagoid`);

--
-- Indices de la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD PRIMARY KEY (`idpermiso`),
  ADD KEY `rolid` (`rolid`),
  ADD KEY `moduloid` (`moduloid`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`idpersona`),
  ADD KEY `rolid` (`rolid`);

--
-- Indices de la tabla `post`
--
ALTER TABLE `post`
  ADD PRIMARY KEY (`idpost`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idproducto`),
  ADD KEY `categoriaid` (`categoriaid`),
  ADD KEY `proveedorid` (`proveedorid`),
  ADD KEY `marcaid` (`marcaid`);

--
-- Indices de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  ADD PRIMARY KEY (`idproveedor`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idrol`);

--
-- Indices de la tabla `tipopago`
--
ALTER TABLE `tipopago`
  ADD PRIMARY KEY (`idtipopago`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `almacen`
--
ALTER TABLE `almacen`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT de la tabla `categoria`
--
ALTER TABLE `categoria`
  MODIFY `idcategoria` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `detalle_ingreso`
--
ALTER TABLE `detalle_ingreso`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT de la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT de la tabla `envio`
--
ALTER TABLE `envio`
  MODIFY `idenvio` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `imagen`
--
ALTER TABLE `imagen`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT de la tabla `marca`
--
ALTER TABLE `marca`
  MODIFY `idmarca` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `modulo`
--
ALTER TABLE `modulo`
  MODIFY `idmodulo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `idpedido` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `permisos`
--
ALTER TABLE `permisos`
  MODIFY `idpermiso` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `idpersona` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `post`
--
ALTER TABLE `post`
  MODIFY `idpost` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idproducto` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `proveedor`
--
ALTER TABLE `proveedor`
  MODIFY `idproveedor` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idrol` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `tipopago`
--
ALTER TABLE `tipopago`
  MODIFY `idtipopago` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `almacen`
--
ALTER TABLE `almacen`
  ADD CONSTRAINT `almacen_ibfk_1` FOREIGN KEY (`productoid`) REFERENCES `producto` (`idproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_ingreso`
--
ALTER TABLE `detalle_ingreso`
  ADD CONSTRAINT `detalle_ingreso_ibfk_1` FOREIGN KEY (`almacenid`) REFERENCES `almacen` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_pedido`
--
ALTER TABLE `detalle_pedido`
  ADD CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`pedidoid`) REFERENCES `pedido` (`idpedido`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`productoid`) REFERENCES `producto` (`idproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `detalle_temp`
--
ALTER TABLE `detalle_temp`
  ADD CONSTRAINT `detalle_temp_ibfk_1` FOREIGN KEY (`productoid`) REFERENCES `producto` (`idproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `imagen`
--
ALTER TABLE `imagen`
  ADD CONSTRAINT `imagen_ibfk_1` FOREIGN KEY (`productoid`) REFERENCES `producto` (`idproducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`personaid`) REFERENCES `persona` (`idpersona`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pedido_ibfk_2` FOREIGN KEY (`tipopagoid`) REFERENCES `tipopago` (`idtipopago`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `permisos`
--
ALTER TABLE `permisos`
  ADD CONSTRAINT `permisos_ibfk_1` FOREIGN KEY (`rolid`) REFERENCES `rol` (`idrol`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permisos_ibfk_2` FOREIGN KEY (`moduloid`) REFERENCES `modulo` (`idmodulo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `persona`
--
ALTER TABLE `persona`
  ADD CONSTRAINT `persona_ibfk_1` FOREIGN KEY (`rolid`) REFERENCES `rol` (`idrol`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`categoriaid`) REFERENCES `categoria` (`idcategoria`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`marcaid`) REFERENCES `marca` (`idmarca`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `producto_ibfk_3` FOREIGN KEY (`proveedorid`) REFERENCES `proveedor` (`idproveedor`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
