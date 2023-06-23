/*
 Navicat MySQL Data Transfer

 Source Server         : NFDb
 Source Server Type    : MySQL
 Source Server Version : 80032 (8.0.32)
 Source Host           : nearfleet.mysql.database.azure.com:3306
 Source Schema         : nearfleet_main

 Target Server Type    : MySQL
 Target Server Version : 80032 (8.0.32)
 File Encoding         : 65001

 Date: 23/06/2023 10:58:46
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for charge_category
-- ----------------------------
DROP TABLE IF EXISTS `charge_category`;
CREATE TABLE `charge_category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_charge_category_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_charge_category_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of charge_category
-- ----------------------------
BEGIN;
INSERT INTO `charge_category` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Base Rate', '2023-05-01 17:17:41', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_category` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Surcharge', '2023-05-01 17:17:41', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_category` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Accessorial Charge', '2023-05-01 17:17:41', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for charge_fee
-- ----------------------------
DROP TABLE IF EXISTS `charge_fee`;
CREATE TABLE `charge_fee` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `charge_type_id` int NOT NULL,
  `shipper_id` bigint NOT NULL,
  `carrier_id` bigint DEFAULT NULL,
  `service_level_id` int DEFAULT NULL,
  `zone_id` bigint DEFAULT NULL,
  `postal_codes` text,
  `weight_threshold` decimal(12,6) DEFAULT NULL,
  `dim_threshold` decimal(12,6) DEFAULT NULL,
  `dim_factor` int DEFAULT NULL,
  `weight_units` int DEFAULT NULL,
  `length_threshold` decimal(12,6) DEFAULT NULL,
  `width_threshold` decimal(12,6) DEFAULT NULL,
  `height_threshold` decimal(12,6) DEFAULT NULL,
  `length_plus_girth_threshold` decimal(12,6) DEFAULT NULL,
  `dimension_units` int DEFAULT NULL,
  `fee_amount` decimal(12,6) DEFAULT NULL,
  `percentage_of_base_rate` decimal(5,2) DEFAULT NULL,
  `currency_id` int DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_charge_fee_tenant_idx` (`tenant_id`),
  KEY `fk_charge_fee_charge_type_idx` (`charge_type_id`),
  KEY `fk_charge_fee_shipper_idx` (`shipper_id`),
  KEY `fk_charge_fee_carrier_idx` (`carrier_id`),
  KEY `fk_charge_fee_weight_units_idx` (`weight_units`),
  KEY `fk_charge_fee_dimension_units_idx` (`dimension_units`),
  KEY `fk_charge_fee_currency_idx` (`currency_id`),
  KEY `fk_charge_fee_service_level_idx` (`service_level_id`),
  KEY `fk_charge_fee_zone_idx` (`zone_id`),
  CONSTRAINT `fk_charge_fee_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_charge_fee_charge_type` FOREIGN KEY (`charge_type_id`) REFERENCES `charge_type` (`id`),
  CONSTRAINT `fk_charge_fee_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`),
  CONSTRAINT `fk_charge_fee_dimension_units` FOREIGN KEY (`dimension_units`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_charge_fee_service_level` FOREIGN KEY (`service_level_id`) REFERENCES `service_level` (`id`),
  CONSTRAINT `fk_charge_fee_shipper` FOREIGN KEY (`shipper_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_charge_fee_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_charge_fee_weight_units` FOREIGN KEY (`weight_units`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_charge_fee_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of charge_fee
-- ----------------------------
BEGIN;
INSERT INTO `charge_fee` (`id`, `tenant_id`, `charge_type_id`, `shipper_id`, `carrier_id`, `service_level_id`, `zone_id`, `postal_codes`, `weight_threshold`, `dim_threshold`, `dim_factor`, `weight_units`, `length_threshold`, `width_threshold`, `height_threshold`, `length_plus_girth_threshold`, `dimension_units`, `fee_amount`, `percentage_of_base_rate`, `currency_id`, `effective_date`, `expiration_date`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 11, 1, 1, NULL, NULL, NULL, 50.000000, 0.000000, 0, 1, 0.000000, 0.000000, 0.000000, 0.000000, 1, 2.000000, NULL, 1, NULL, NULL, '2023-05-27 20:19:38', 'Tony Sziklai', '2023-05-30 12:02:51', 'Tony Sziklai');
COMMIT;

-- ----------------------------
-- Table structure for charge_type
-- ----------------------------
DROP TABLE IF EXISTS `charge_type`;
CREATE TABLE `charge_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `category_id` int NOT NULL COMMENT 'As relates to charge_category',
  `scheme` enum('Flat','Per Unit','Tiered') DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `condition` text,
  `stripe_product_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_charge_type_tenant_id_idx` (`tenant_id`),
  KEY `fk_charge_type_category_idx` (`category_id`),
  CONSTRAINT `fk_charge_type_category` FOREIGN KEY (`category_id`) REFERENCES `charge_category` (`id`),
  CONSTRAINT `fk_charge_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of charge_type
-- ----------------------------
BEGIN;
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 'Flat', 'Per Delivery Base Rate', NULL, NULL, NULL, '2023-05-01 19:01:44', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 1, 'Tiered', 'Per Weight Range Base Rate', NULL, 'package.weight >= rate_contract_base_rate.min_value and < rate_contract_base_rate.max_value ', NULL, '2023-05-01 19:01:45', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 1, 'Tiered', 'Per Dim Weight Range Base Rate', NULL, NULL, NULL, '2023-05-01 19:01:45', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 1, 'Tiered', 'Per Cubic Range Base Rate', NULL, NULL, NULL, '2023-05-01 19:01:45', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 1, 'Per Unit', 'Per Distance Base Rate', NULL, NULL, NULL, '2023-05-01 19:01:45', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 1, 'Tiered', 'Per Distance Range Base Rate', NULL, NULL, NULL, '2023-05-01 19:01:45', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (7, 1, 1, 'Per Unit', 'Per Minute Base Rate', NULL, NULL, NULL, '2023-05-01 19:01:45', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (8, 1, 1, 'Tiered', 'Per Minute Range Base Rate', NULL, NULL, NULL, '2023-05-01 19:01:46', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (9, 1, 2, 'Flat', 'Delivery Area Surcharge -  Residential', NULL, '', NULL, '2023-05-01 19:01:46', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (10, 1, 2, 'Flat', 'Delivery Area Surcharge - Commercial', NULL, NULL, NULL, '2023-05-01 19:01:46', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (11, 1, 2, 'Flat', 'Large Package Surcharge - Residential', NULL, NULL, NULL, '2023-05-01 19:01:46', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (12, 1, 2, 'Flat', 'Large Package Surcharge - Commercial', NULL, NULL, NULL, '2023-05-01 19:01:46', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (13, 1, 2, 'Flat', 'Handling Fee - Weight', NULL, 'package.weight >= charge_fee.weight_threshold', NULL, '2023-05-01 19:01:46', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (14, 1, 2, 'Flat', 'Handling Fee - Dimension', NULL, 'package.length >= charge_fee.length_threshold', NULL, '2023-05-01 19:01:47', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (15, 1, 2, 'Flat', 'Handling Fee - Non-standard Packaging', NULL, 'package.non_standard_packaging=1', NULL, '2023-05-01 19:01:47', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (16, 1, 3, 'Flat', 'Address Correction', NULL, NULL, NULL, '2023-05-01 19:01:47', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (29, 1, 3, 'Flat', 'Delivery Confirmation', NULL, 'package.delivery_confirmation=1', NULL, '2023-06-22 02:38:54', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (30, 1, 3, 'Flat', 'Signature', NULL, 'package.signature_required=1', NULL, '2023-06-22 02:38:55', 'Tony Sziklai', NULL, NULL);
INSERT INTO `charge_type` (`id`, `tenant_id`, `category_id`, `scheme`, `name`, `description`, `condition`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (31, 1, 3, 'Flat', 'Proof-of-Delivery', NULL, 'package.proof_of_delivery=1', NULL, '2023-06-22 02:41:37', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for country
-- ----------------------------
DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `code` varchar(2) NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_country_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_country_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of country
-- ----------------------------
BEGIN;
INSERT INTO `country` (`id`, `tenant_id`, `code`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'US', 'United States', '2023-04-17 14:57:43', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for currency
-- ----------------------------
DROP TABLE IF EXISTS `currency`;
CREATE TABLE `currency` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `code` varchar(3) NOT NULL,
  `symbol` varchar(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_currency_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_currency_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of currency
-- ----------------------------
BEGIN;
INSERT INTO `currency` (`id`, `tenant_id`, `name`, `code`, `symbol`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'US Dollar', 'USD', '$', '2023-04-15 00:47:20', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for customs_defaults
-- ----------------------------
DROP TABLE IF EXISTS `customs_defaults`;
CREATE TABLE `customs_defaults` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `client_id` bigint NOT NULL,
  `customs_declaration_required` tinyint DEFAULT NULL,
  `use_defaults_if_blank` tinyint DEFAULT NULL,
  `default_contents_type` varchar(255) DEFAULT NULL,
  `default_non_delivery_option` varchar(255) DEFAULT NULL,
  `default_item_category` varchar(255) DEFAULT NULL,
  `default_item_description` varchar(255) DEFAULT NULL,
  `default_item_quantity` int DEFAULT NULL,
  `default_item_country_of_origin` varchar(2) DEFAULT NULL,
  `default_item_declared_value` decimal(10,2) DEFAULT NULL,
  `default_currency_id` int DEFAULT NULL,
  `default_item_harmonized_tariff_code` varchar(255) DEFAULT NULL,
  `sign_customs_documents_as` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_customs_defaults_tenant_idx` (`tenant_id`),
  KEY `fk_customs_defaults_client_idx` (`client_id`),
  KEY `fk_customs_defaults_currency_idx` (`default_currency_id`),
  CONSTRAINT `fk_customs_defaults_client` FOREIGN KEY (`client_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_customs_defaults_currency` FOREIGN KEY (`default_currency_id`) REFERENCES `currency` (`id`),
  CONSTRAINT `fk_customs_defaults_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of customs_defaults
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for customs_status
-- ----------------------------
DROP TABLE IF EXISTS `customs_status`;
CREATE TABLE `customs_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_customs_status_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_customs_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of customs_status
-- ----------------------------
BEGIN;
INSERT INTO `customs_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Pending', NULL, NULL, '2023-04-25 20:53:43', 'Tony Sziklai', NULL, NULL);
INSERT INTO `customs_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Cleared', NULL, NULL, '2023-04-25 20:53:43', 'Tony Sziklai', NULL, NULL);
INSERT INTO `customs_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Held for Inspection', NULL, NULL, '2023-04-25 20:53:43', 'Tony Sziklai', NULL, NULL);
INSERT INTO `customs_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Held for Payment', NULL, NULL, '2023-04-25 20:53:43', 'Tony Sziklai', NULL, NULL);
INSERT INTO `customs_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Under Quarantine', NULL, NULL, '2023-04-25 20:53:43', 'Tony Sziklai', NULL, NULL);
INSERT INTO `customs_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 'Rejected', NULL, NULL, '2023-05-02 18:27:42', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for customs_status_mapping
-- ----------------------------
DROP TABLE IF EXISTS `customs_status_mapping`;
CREATE TABLE `customs_status_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `customs_status_id` int NOT NULL,
  `mapped_name` varchar(255) NOT NULL,
  `mapped_description` varchar(500) DEFAULT NULL,
  `mapped_code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_customs_status_mapping_tenant_idx` (`tenant_id`),
  KEY `fk_customs_status_mapping_org_idx` (`org_id`),
  KEY `fk_customs_status_mapping_customs_status_idx` (`customs_status_id`),
  CONSTRAINT `fk_customs_status_mapping_customs_status` FOREIGN KEY (`customs_status_id`) REFERENCES `customs_status` (`id`),
  CONSTRAINT `fk_customs_status_mapping_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_customs_status_mapping_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of customs_status_mapping
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for delivery_confirmation_type
-- ----------------------------
DROP TABLE IF EXISTS `delivery_confirmation_type`;
CREATE TABLE `delivery_confirmation_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `email_or_text` enum('Email','Text') NOT NULL,
  `name` varchar(80) NOT NULL,
  `subject_line` varchar(255) DEFAULT NULL,
  `template_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_delivery_confirmation_type_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_delivery_confirmation_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of delivery_confirmation_type
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for event_type
-- ----------------------------
DROP TABLE IF EXISTS `event_type`;
CREATE TABLE `event_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `code` varchar(80) DEFAULT NULL,
  `package_status_id` int DEFAULT NULL,
  `customs_status_id` int DEFAULT NULL,
  `visible_to_clients` tinyint DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_event_type_tenant_idx` (`tenant_id`),
  KEY `fk_event_type_package_status_idx` (`package_status_id`),
  KEY `fk_event_type_customs_status_idx` (`customs_status_id`),
  CONSTRAINT `fk_event_type_customs_status` FOREIGN KEY (`customs_status_id`) REFERENCES `customs_status` (`id`),
  CONSTRAINT `fk_event_type_package_status` FOREIGN KEY (`package_status_id`) REFERENCES `package_status` (`id`),
  CONSTRAINT `fk_event_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of event_type
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for event_type_mapping
-- ----------------------------
DROP TABLE IF EXISTS `event_type_mapping`;
CREATE TABLE `event_type_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `event_type_id` int NOT NULL,
  `mapped_name` varchar(255) NOT NULL,
  `mapped_description` varchar(500) DEFAULT NULL,
  `mapped_code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_event_type_mapping_tenant_idx` (`tenant_id`),
  KEY `fk_event_type_mapping_org_idx` (`org_id`),
  KEY `fk_event_type_mapping_event_type_idx` (`event_type_id`),
  CONSTRAINT `fk_event_type_mapping_event_type` FOREIGN KEY (`event_type_id`) REFERENCES `event_type` (`id`),
  CONSTRAINT `fk_event_type_mapping_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_event_type_mapping_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of event_type_mapping
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for file_format
-- ----------------------------
DROP TABLE IF EXISTS `file_format`;
CREATE TABLE `file_format` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_file_format_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_file_format_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of file_format
-- ----------------------------
BEGIN;
INSERT INTO `file_format` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'PDF', '2023-04-25 18:04:49', 'Tony Sziklai', NULL, NULL);
INSERT INTO `file_format` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'PNG', '2023-04-25 18:04:50', 'Tony Sziklai', NULL, NULL);
INSERT INTO `file_format` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'JPG', '2023-04-25 18:04:50', 'Tony Sziklai', NULL, NULL);
INSERT INTO `file_format` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'ZPL', '2023-04-25 18:04:50', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for hub
-- ----------------------------
DROP TABLE IF EXISTS `hub`;
CREATE TABLE `hub` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `name` varchar(80) NOT NULL,
  `is_default_ship_from_hub` tinyint DEFAULT NULL,
  `address_name` varchar(80) DEFAULT NULL,
  `address_line_1` varchar(255) DEFAULT NULL,
  `address_line_2` varchar(255) DEFAULT NULL,
  `city_locality` varchar(80) DEFAULT NULL,
  `state_province` varchar(80) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `country` varchar(2) DEFAULT NULL,
  `lat` decimal(8,6) DEFAULT NULL,
  `long` decimal(9,6) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_node_tenant_idx` (`tenant_id`),
  KEY `fk_node_org_idx` (`org_id`),
  CONSTRAINT `fk_node_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_node_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of hub
-- ----------------------------
BEGIN;
INSERT INTO `hub` (`id`, `tenant_id`, `org_id`, `name`, `is_default_ship_from_hub`, `address_name`, `address_line_1`, `address_line_2`, `city_locality`, `state_province`, `postal_code`, `country`, `lat`, `long`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 4, 'Transfer Point', NULL, 'ALS Logistics', '204 Logistics Way', NULL, 'Los Angeles', 'CA', '90230', 'US', NULL, NULL, '2023-04-17 17:49:57', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for invoice_status
-- ----------------------------
DROP TABLE IF EXISTS `invoice_status`;
CREATE TABLE `invoice_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_invoice_status_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_invoice_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of invoice_status
-- ----------------------------
BEGIN;
INSERT INTO `invoice_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Draft', '2023-05-22 22:24:55', 'Tony Sziklai', NULL, NULL);
INSERT INTO `invoice_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Open', '2023-05-22 22:24:56', 'Tony Sziklai', NULL, NULL);
INSERT INTO `invoice_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Paid', '2023-05-22 22:24:56', 'Tony Sziklai', NULL, NULL);
INSERT INTO `invoice_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Uncollectible', '2023-05-22 22:24:56', 'Tony Sziklai', NULL, NULL);
INSERT INTO `invoice_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Void', '2023-05-22 22:24:56', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for label_type
-- ----------------------------
DROP TABLE IF EXISTS `label_type`;
CREATE TABLE `label_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `layout_length` decimal(12,6) DEFAULT NULL,
  `layout_height` decimal(12,6) DEFAULT NULL,
  `units_id` int DEFAULT NULL,
  `dots_per_inch` int DEFAULT NULL,
  `template_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `label_type_tenant_idx` (`tenant_id`),
  KEY `label_type_units_idx` (`units_id`),
  CONSTRAINT `label_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `label_type_units` FOREIGN KEY (`units_id`) REFERENCES `units` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of label_type
-- ----------------------------
BEGIN;
INSERT INTO `label_type` (`id`, `tenant_id`, `name`, `layout_length`, `layout_height`, `units_id`, `dots_per_inch`, `template_url`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Delivery Label', 4.000000, 6.000000, 2, NULL, NULL, '2023-04-25 18:15:37', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org
-- ----------------------------
DROP TABLE IF EXISTS `org`;
CREATE TABLE `org` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `type` enum('Carrier','Client','Shipper') NOT NULL,
  `uuid` varchar(64) NOT NULL,
  `tax_id` varchar(255) DEFAULT NULL,
  `state_province_tax_id` varchar(255) DEFAULT NULL,
  `stripe_customer_id` varchar(255) DEFAULT NULL,
  `is_main_org` tinyint DEFAULT NULL,
  `parent_org_id` bigint DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid_UNIQUE` (`uuid`),
  KEY `fk_org_parent_org_idx` (`parent_org_id`),
  KEY `fk_org_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_org_parent_org` FOREIGN KEY (`parent_org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_org_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org
-- ----------------------------
BEGIN;
INSERT INTO `org` (`id`, `tenant_id`, `name`, `type`, `uuid`, `tax_id`, `state_province_tax_id`, `stripe_customer_id`, `is_main_org`, `parent_org_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'ALS Global', 'Shipper', '0ae89fec-dbbd-11ed-b88e-6045bded84f9', NULL, NULL, NULL, 1, NULL, '2023-04-15 18:40:49', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org` (`id`, `tenant_id`, `name`, `type`, `uuid`, `tax_id`, `state_province_tax_id`, `stripe_customer_id`, `is_main_org`, `parent_org_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Acme Product Co.', 'Client', '0f38c3a9-e0a7-4e9f-a332-8b1a225e1e7b', NULL, NULL, NULL, NULL, NULL, '2023-05-02 19:59:01', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org` (`id`, `tenant_id`, `name`, `type`, `uuid`, `tax_id`, `state_province_tax_id`, `stripe_customer_id`, `is_main_org`, `parent_org_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'United Consumer Goods', 'Client', '413dfcc2-8e58-4d1f-a6b5-5c5c00cfba15', NULL, NULL, NULL, NULL, NULL, '2023-05-02 19:57:51', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org` (`id`, `tenant_id`, `name`, `type`, `uuid`, `tax_id`, `state_province_tax_id`, `stripe_customer_id`, `is_main_org`, `parent_org_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'ALS Los Angeles', 'Shipper', '5d5af5b4-a5c5-4e48-9c36-d6107b833a72', NULL, NULL, NULL, NULL, NULL, '2023-05-09 17:17:49', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org` (`id`, `tenant_id`, `name`, `type`, `uuid`, `tax_id`, `state_province_tax_id`, `stripe_customer_id`, `is_main_org`, `parent_org_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Reliable Delivery Co.', 'Carrier', '1d221a17-0d5e-4435-a272-8aeb3a05b2f4', NULL, NULL, 'cus_test_1234567890abcdefghijklmnopqrstuvwxyz', 1, NULL, '2023-05-10 02:43:29', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org` (`id`, `tenant_id`, `name`, `type`, `uuid`, `tax_id`, `state_province_tax_id`, `stripe_customer_id`, `is_main_org`, `parent_org_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 2, 'Super Duper Shipping Co.', 'Carrier', '213dfcc2-8e58-4d1f-a6b5-5c5c00cfba67', NULL, NULL, NULL, NULL, NULL, '2023-05-10 04:22:26', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_preferences
-- ----------------------------
DROP TABLE IF EXISTS `org_preferences`;
CREATE TABLE `org_preferences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `language` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `currency_id` int DEFAULT NULL,
  `time_format` varchar(255) DEFAULT NULL,
  `date_format` varchar(255) DEFAULT NULL,
  `time_zone` varchar(255) DEFAULT NULL,
  `measurement_system` enum('Metric','Imperial') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `time_units_id` int DEFAULT NULL,
  `distance_units_id` int DEFAULT NULL,
  `weight_units_id` int DEFAULT NULL,
  `dimension_units_id` int DEFAULT NULL,
  `cubic_units_id` int DEFAULT NULL,
  `print_rate_on_label` tinyint DEFAULT NULL,
  `include_return_label` tinyint DEFAULT NULL,
  `shipping_cutoff_time` time DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_org_preferences_tenant_idx` (`tenant_id`) USING BTREE,
  KEY `fk_org_preferences_shipper_idx` (`org_id`) USING BTREE,
  KEY `fk_org_preferences_weight_units_idx` (`weight_units_id`) USING BTREE,
  KEY `fk_org_preferences_dimension_units_idx` (`dimension_units_id`) USING BTREE,
  KEY `fk_org_preferences_cubic_units_idx` (`cubic_units_id`) USING BTREE,
  KEY `fk_org_preferences_currency_idx` (`currency_id`) USING BTREE,
  KEY `fk_org_preferences_time_units_idx` (`time_units_id`) USING BTREE,
  KEY `fk_org_preferences_distance_units_idx` (`distance_units_id`) USING BTREE,
  CONSTRAINT `fk_org_preferences_cubic_units` FOREIGN KEY (`cubic_units_id`) REFERENCES `units` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_org_preferences_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_org_preferences_dimension_units` FOREIGN KEY (`dimension_units_id`) REFERENCES `units` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_org_preferences_distance_units` FOREIGN KEY (`distance_units_id`) REFERENCES `units` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_org_preferences_shipper` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_org_preferences_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_org_preferences_time_units` FOREIGN KEY (`time_units_id`) REFERENCES `units` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_org_preferences_weight_units` FOREIGN KEY (`weight_units_id`) REFERENCES `units` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_preferences
-- ----------------------------
BEGIN;
INSERT INTO `org_preferences` (`id`, `tenant_id`, `org_id`, `language`, `currency_id`, `time_format`, `date_format`, `time_zone`, `measurement_system`, `time_units_id`, `distance_units_id`, `weight_units_id`, `dimension_units_id`, `cubic_units_id`, `print_rate_on_label`, `include_return_label`, `shipping_cutoff_time`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 'en-us', 1, NULL, NULL, NULL, 'Imperial', NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, '2023-05-27 20:35:53', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_pricing_model
-- ----------------------------
DROP TABLE IF EXISTS `org_pricing_model`;
CREATE TABLE `org_pricing_model` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `stripe_product_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_pricing_model_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_org_pricing_model_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_pricing_model
-- ----------------------------
BEGIN;
INSERT INTO `org_pricing_model` (`id`, `tenant_id`, `name`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Flat Fee per Package', 'prod_abc123', '2023-05-09 00:47:06', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_pricing_model` (`id`, `tenant_id`, `name`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Percentage of Package Base Rate', 'prod_def456', '2023-05-09 00:47:06', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_pricing_model` (`id`, `tenant_id`, `name`, `stripe_product_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Percentage of Package Charges (All)', 'prod_ghi789', '2023-05-09 00:48:09', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_pricing_plan
-- ----------------------------
DROP TABLE IF EXISTS `org_pricing_plan`;
CREATE TABLE `org_pricing_plan` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `pricing_model_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency_id` int DEFAULT NULL,
  `percentage` decimal(5,2) DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `billing_cycle_days` int DEFAULT '30',
  `status_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_pricing_plan_tenant_idx` (`tenant_id`),
  KEY `fk_org_pricing_plan_org_idx` (`org_id`),
  KEY `fk_org_pricing_plan_status_idx` (`status_id`),
  KEY `fk_org_pricing_plan_pricing_model_idx` (`pricing_model_id`),
  CONSTRAINT `fk_org_pricing_plan_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_org_pricing_plan_pricing_model` FOREIGN KEY (`pricing_model_id`) REFERENCES `org_pricing_model` (`id`),
  CONSTRAINT `fk_org_pricing_plan_status` FOREIGN KEY (`status_id`) REFERENCES `org_pricing_status` (`id`),
  CONSTRAINT `fk_org_pricing_plan_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_pricing_plan
-- ----------------------------
BEGIN;
INSERT INTO `org_pricing_plan` (`id`, `tenant_id`, `org_id`, `pricing_model_id`, `amount`, `currency_id`, `percentage`, `effective_date`, `expiration_date`, `billing_cycle_days`, `status_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 4, 1, 1.50, 1, NULL, '2023-07-01', NULL, 30, NULL, '2023-05-10 02:48:39', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_pricing_status
-- ----------------------------
DROP TABLE IF EXISTS `org_pricing_status`;
CREATE TABLE `org_pricing_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_pricing_status_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_org_pricing_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_pricing_status
-- ----------------------------
BEGIN;
INSERT INTO `org_pricing_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Trial', '2023-05-08 22:53:24', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_pricing_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Active', '2023-05-08 22:53:25', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_pricing_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Past Due', '2023-05-08 22:53:25', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_pricing_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Canceled', '2023-05-08 22:53:25', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_pricing_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Unpaid', '2023-05-08 22:53:25', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_pricing_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 'Incomplete', '2023-05-08 22:53:25', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_saas_invoice
-- ----------------------------
DROP TABLE IF EXISTS `org_saas_invoice`;
CREATE TABLE `org_saas_invoice` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `pricing_plan_id` bigint NOT NULL,
  `stripe_invoice_id` varchar(255) DEFAULT NULL,
  `stripe_payment_intent_id` varchar(255) DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `invoice_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_saas_invoice_tenant_idx` (`tenant_id`),
  KEY `fk_org_saas_invoice_org_idx` (`org_id`),
  KEY `fk_org_saas_invoice_pricing_plan_idx` (`pricing_plan_id`),
  KEY `fk_org_saas_invoice_status_idx` (`status_id`),
  CONSTRAINT `fk_org_saas_invoice_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_org_saas_invoice_pricing_plan` FOREIGN KEY (`pricing_plan_id`) REFERENCES `org_pricing_plan` (`id`),
  CONSTRAINT `fk_org_saas_invoice_status` FOREIGN KEY (`status_id`) REFERENCES `invoice_status` (`id`),
  CONSTRAINT `fk_org_saas_invoice_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_saas_invoice
-- ----------------------------
BEGIN;
INSERT INTO `org_saas_invoice` (`id`, `tenant_id`, `org_id`, `pricing_plan_id`, `stripe_invoice_id`, `stripe_payment_intent_id`, `status_id`, `due_date`, `invoice_url`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 4, 1, 'in_123456789012345678901234', 'pi_123456789012345678901234', NULL, NULL, NULL, '2023-05-10 03:35:33', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_saas_transaction
-- ----------------------------
DROP TABLE IF EXISTS `org_saas_transaction`;
CREATE TABLE `org_saas_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `package_id` bigint NOT NULL,
  `pricing_plan_id` bigint NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency_id` int DEFAULT NULL,
  `stripe_invoice_id` varchar(255) DEFAULT NULL,
  `stripe_invoice_item_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_saas_transaction_tenant_idx` (`tenant_id`),
  KEY `fk_org_saas_transaction_org_idx` (`org_id`),
  KEY `fk_org_saas_transaction_package_idx` (`package_id`),
  KEY `fk_org_saas_transaction_currency_idx` (`currency_id`),
  KEY `fk_org_saas_transaction_pricing_plan_idx` (`pricing_plan_id`),
  CONSTRAINT `fk_org_saas_transaction_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`),
  CONSTRAINT `fk_org_saas_transaction_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_org_saas_transaction_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `fk_org_saas_transaction_pricing_plan` FOREIGN KEY (`pricing_plan_id`) REFERENCES `org_pricing_plan` (`id`),
  CONSTRAINT `fk_org_saas_transaction_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_saas_transaction
-- ----------------------------
BEGIN;
INSERT INTO `org_saas_transaction` (`id`, `tenant_id`, `org_id`, `package_id`, `pricing_plan_id`, `amount`, `currency_id`, `stripe_invoice_id`, `stripe_invoice_item_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 4, 1, 1, 1.50, 1, 'in_123456789012345678901234', 'ii_123456789012345678901234', '2023-05-10 03:43:33', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_tax_identifier
-- ----------------------------
DROP TABLE IF EXISTS `org_tax_identifier`;
CREATE TABLE `org_tax_identifier` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `tax_identifier_type_id` int NOT NULL,
  `tax_identifier_value` varchar(255) NOT NULL,
  `issuing_country` varchar(2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_tax_identifier_tenant_idx` (`tenant_id`),
  KEY `fk_org_tax_identifier_org_idx` (`org_id`),
  KEY `fk_org_tax_identifier_type_idx` (`tax_identifier_type_id`),
  CONSTRAINT `fk_org_tax_identifier_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_org_tax_identifier_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_org_tax_identifier_type` FOREIGN KEY (`tax_identifier_type_id`) REFERENCES `tax_identifier_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of org_tax_identifier
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for org_type
-- ----------------------------
DROP TABLE IF EXISTS `org_type`;
CREATE TABLE `org_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_type_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_org_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_type
-- ----------------------------
BEGIN;
INSERT INTO `org_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Client', '2023-04-14 20:58:05', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Shipper', '2023-04-14 20:59:02', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Carrier', '2023-04-14 20:59:59', 'Tony Sziklai', NULL, NULL);
INSERT INTO `org_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Shipper Fleet', '2023-04-19 18:57:28', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_user
-- ----------------------------
DROP TABLE IF EXISTS `org_user`;
CREATE TABLE `org_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `org_owner` tinyint NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_user_org_idx` (`org_id`),
  KEY `fk_org_user_user_idx` (`user_id`),
  KEY `fk_org_user_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_org_user_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_org_user_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_org_user_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_user
-- ----------------------------
BEGIN;
INSERT INTO `org_user` (`id`, `tenant_id`, `org_id`, `user_id`, `org_owner`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 1, 1, '2023-04-17 15:00:29', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for org_user_role
-- ----------------------------
DROP TABLE IF EXISTS `org_user_role`;
CREATE TABLE `org_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_user_id` bigint NOT NULL,
  `role_type_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_org_user_role_org_user_idx` (`org_user_id`),
  KEY `fk_org_user_role_role_type_idx` (`role_type_id`),
  KEY `fk_org_user_role_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_org_user_role_org_user` FOREIGN KEY (`org_user_id`) REFERENCES `org_user` (`id`),
  CONSTRAINT `fk_org_user_role_role_type` FOREIGN KEY (`role_type_id`) REFERENCES `role_type` (`id`),
  CONSTRAINT `fk_org_user_role_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of org_user_role
-- ----------------------------
BEGIN;
INSERT INTO `org_user_role` (`id`, `tenant_id`, `org_user_id`, `role_type_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 1, '2023-04-17 15:01:21', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for package
-- ----------------------------
DROP TABLE IF EXISTS `package`;
CREATE TABLE `package` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `shipper_id` bigint NOT NULL,
  `client_id` bigint DEFAULT NULL,
  `upload_file_id` bigint DEFAULT NULL,
  `order_id` varchar(255) DEFAULT NULL,
  `shipment_id` varchar(255) DEFAULT NULL,
  `client_package_id` varchar(255) DEFAULT NULL,
  `tracking_number` varchar(255) DEFAULT NULL,
  `barcode` blob,
  `qr_code` blob,
  `status_id` int DEFAULT NULL,
  `zone_id` bigint DEFAULT NULL,
  `work_area_id` bigint DEFAULT NULL,
  `carrier_id` bigint DEFAULT NULL,
  `service_level_id` int DEFAULT NULL,
  `vehicle_type_id` int DEFAULT NULL,
  `driver_id` bigint DEFAULT NULL,
  `ship_from_hub_id` bigint DEFAULT NULL,
  `ship_from_name` varchar(80) DEFAULT NULL,
  `ship_from_address_1` varchar(255) DEFAULT NULL,
  `ship_from_address_2` varchar(255) DEFAULT NULL,
  `ship_from_city_locality` varchar(80) DEFAULT NULL,
  `ship_from_state_province` varchar(80) DEFAULT NULL,
  `ship_from_postal_code` varchar(20) DEFAULT NULL,
  `ship_from_country` varchar(2) DEFAULT NULL,
  `ship_from_lat` decimal(8,6) DEFAULT NULL,
  `ship_from_long` decimal(9,6) DEFAULT NULL,
  `ship_to_name` varchar(80) DEFAULT NULL,
  `ship_to_address_1` varchar(255) DEFAULT NULL,
  `ship_to_address_2` varchar(255) DEFAULT NULL,
  `ship_to_city_locality` varchar(80) DEFAULT NULL,
  `ship_to_state_province` varchar(80) DEFAULT NULL,
  `ship_to_country` varchar(2) DEFAULT NULL,
  `ship_to_lat` decimal(8,6) DEFAULT NULL,
  `ship_to_long` decimal(9,6) DEFAULT NULL,
  `ship_to_residential_or_commercial` enum('Residential','Commercial') DEFAULT NULL,
  `ship_to_is_po_box` tinyint DEFAULT NULL,
  `ship_to_is_apo_fpo` tinyint DEFAULT NULL,
  `ship_to_is_high_rise` tinyint DEFAULT NULL,
  `customer_email_address` varchar(255) DEFAULT NULL,
  `customer_phone` varchar(20) DEFAULT NULL,
  `customer_whatsapp` varchar(20) DEFAULT NULL,
  `delivery_instructions` text,
  `do_not_safe_drop` tinyint DEFAULT NULL,
  `delivery_confirmation` tinyint DEFAULT NULL,
  `signature_required` tinyint DEFAULT NULL,
  `adult_signature_required` tinyint DEFAULT NULL,
  `signature_url` varchar(255) DEFAULT NULL,
  `addressee_only` tinyint DEFAULT NULL,
  `proof_of_delivery` tinyint DEFAULT NULL,
  `proof_photo_url` varchar(255) DEFAULT NULL,
  `proof_photo2_url` varchar(255) DEFAULT NULL,
  `scheduled_delivery_date` date DEFAULT NULL,
  `scheduled_window_from` time DEFAULT NULL,
  `scheduled_window_to` time DEFAULT NULL,
  `actual_delivery_date` date DEFAULT NULL,
  `actual_delivery_time` time DEFAULT NULL,
  `saturday_delivery` tinyint DEFAULT NULL,
  `weight` decimal(12,6) DEFAULT NULL,
  `weight_units_id` int DEFAULT NULL,
  `length` decimal(12,6) DEFAULT NULL,
  `width` decimal(12,6) DEFAULT NULL,
  `height` decimal(12,6) DEFAULT NULL,
  `dimension_units_id` int DEFAULT NULL,
  `non_machinable` tinyint DEFAULT NULL,
  `non_standard_packaging` tinyint DEFAULT NULL,
  `is_fragile` tinyint DEFAULT NULL,
  `is_tobacco` tinyint DEFAULT NULL,
  `is_alcohol` tinyint DEFAULT NULL,
  `id_photo_url` varchar(255) DEFAULT NULL,
  `id_photo2_url` varchar(255) DEFAULT NULL,
  `is_hazardous` tinyint DEFAULT NULL,
  `is_restricted` tinyint DEFAULT NULL,
  `is_perishable` tinyint DEFAULT NULL,
  `includes_dry_ice` tinyint DEFAULT NULL,
  `temp_control_required` tinyint DEFAULT NULL,
  `is_insured` tinyint DEFAULT NULL,
  `insurance_provider` varchar(255) DEFAULT NULL,
  `insurance_policy` varchar(255) DEFAULT NULL,
  `insurance_amount` decimal(10,2) DEFAULT NULL,
  `customs_declaration_required` tinyint DEFAULT NULL,
  `importer_of_record` varchar(255) DEFAULT NULL,
  `exporter_of_record` varchar(255) DEFAULT NULL,
  `customs_contents_type` varchar(255) DEFAULT NULL,
  `customs_item_quantity` int DEFAULT NULL,
  `customs_non_delivery_option` varchar(255) DEFAULT NULL,
  `customs_declaration_number` varchar(255) DEFAULT NULL,
  `customs_status_id` int DEFAULT NULL,
  `total_minutes` decimal(12,6) DEFAULT NULL,
  `total_distance` decimal(12,6) DEFAULT NULL,
  `distance_units_id` int DEFAULT NULL,
  `odometer_start` int DEFAULT NULL,
  `odometer_end` int DEFAULT NULL,
  `total_duties_tariffs_taxes` decimal(10,2) DEFAULT NULL,
  `base_shipping_rate` decimal(10,2) DEFAULT NULL,
  `total_shipping_charges` decimal(10,2) DEFAULT NULL,
  `currency_id` int DEFAULT NULL,
  `is_return` tinyint DEFAULT NULL,
  `rma_number` varchar(255) DEFAULT NULL,
  `return_label_url` varchar(255) DEFAULT NULL,
  `tags` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `fk_package_tenant_idx` (`tenant_id`),
  KEY `fk_package_shipper_idx` (`shipper_id`),
  KEY `fk_package_client_idx` (`client_id`),
  KEY `fk_package_carrier_idx` (`carrier_id`),
  KEY `fk_package_driver_idx` (`driver_id`) /*!80000 INVISIBLE */,
  KEY `fk_package_ship_from_hub_idx` (`ship_from_hub_id`),
  KEY `fk_package_status_idx` (`status_id`),
  KEY `fk_package_currency_idx` (`currency_id`),
  KEY `fk_package_weight_units_idx` (`weight_units_id`),
  KEY `fk_package_dimension_units_idx` (`dimension_units_id`),
  KEY `fk_package_customs_status_idx` (`customs_status_id`),
  KEY `fk_package_service_level_idx` (`service_level_id`),
  KEY `fk_package_zone_idx` (`zone_id`),
  KEY `fk_package_distance_units_idx` (`distance_units_id`),
  KEY `fk_package_vehicle_type_idx` (`vehicle_type_id`),
  KEY `fk_package_work_area_idx` (`work_area_id`),
  CONSTRAINT `fk_package_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_package_client` FOREIGN KEY (`client_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_package_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`),
  CONSTRAINT `fk_package_customs_status` FOREIGN KEY (`customs_status_id`) REFERENCES `customs_status` (`id`),
  CONSTRAINT `fk_package_dimension_units` FOREIGN KEY (`dimension_units_id`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_package_distance_units` FOREIGN KEY (`distance_units_id`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_package_driver` FOREIGN KEY (`driver_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_package_service_level` FOREIGN KEY (`service_level_id`) REFERENCES `service_level` (`id`),
  CONSTRAINT `fk_package_ship_from_hub` FOREIGN KEY (`ship_from_hub_id`) REFERENCES `hub` (`id`),
  CONSTRAINT `fk_package_shipper` FOREIGN KEY (`shipper_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_package_status` FOREIGN KEY (`status_id`) REFERENCES `package_status` (`id`),
  CONSTRAINT `fk_package_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_package_vehicle_type` FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicle_type` (`id`),
  CONSTRAINT `fk_package_weight_units` FOREIGN KEY (`weight_units_id`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_package_work_area` FOREIGN KEY (`work_area_id`) REFERENCES `work_area` (`id`),
  CONSTRAINT `fk_package_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of package
-- ----------------------------
BEGIN;
INSERT INTO `package` (`id`, `tenant_id`, `shipper_id`, `client_id`, `upload_file_id`, `order_id`, `shipment_id`, `client_package_id`, `tracking_number`, `barcode`, `qr_code`, `status_id`, `zone_id`, `work_area_id`, `carrier_id`, `service_level_id`, `vehicle_type_id`, `driver_id`, `ship_from_hub_id`, `ship_from_name`, `ship_from_address_1`, `ship_from_address_2`, `ship_from_city_locality`, `ship_from_state_province`, `ship_from_postal_code`, `ship_from_country`, `ship_from_lat`, `ship_from_long`, `ship_to_name`, `ship_to_address_1`, `ship_to_address_2`, `ship_to_city_locality`, `ship_to_state_province`, `ship_to_country`, `ship_to_lat`, `ship_to_long`, `ship_to_residential_or_commercial`, `ship_to_is_po_box`, `ship_to_is_apo_fpo`, `ship_to_is_high_rise`, `customer_email_address`, `customer_phone`, `customer_whatsapp`, `delivery_instructions`, `do_not_safe_drop`, `delivery_confirmation`, `signature_required`, `adult_signature_required`, `signature_url`, `addressee_only`, `proof_of_delivery`, `proof_photo_url`, `proof_photo2_url`, `scheduled_delivery_date`, `scheduled_window_from`, `scheduled_window_to`, `actual_delivery_date`, `actual_delivery_time`, `saturday_delivery`, `weight`, `weight_units_id`, `length`, `width`, `height`, `dimension_units_id`, `non_machinable`, `non_standard_packaging`, `is_fragile`, `is_tobacco`, `is_alcohol`, `id_photo_url`, `id_photo2_url`, `is_hazardous`, `is_restricted`, `is_perishable`, `includes_dry_ice`, `temp_control_required`, `is_insured`, `insurance_provider`, `insurance_policy`, `insurance_amount`, `customs_declaration_required`, `importer_of_record`, `exporter_of_record`, `customs_contents_type`, `customs_item_quantity`, `customs_non_delivery_option`, `customs_declaration_number`, `customs_status_id`, `total_minutes`, `total_distance`, `distance_units_id`, `odometer_start`, `odometer_end`, `total_duties_tariffs_taxes`, `base_shipping_rate`, `total_shipping_charges`, `currency_id`, `is_return`, `rma_number`, `return_label_url`, `tags`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 4, 2, NULL, '346257684454', '2356754347', '943687895', '254679445787093356', NULL, NULL, 2, 1, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-05-10 03:40:18', NULL, NULL, NULL);
INSERT INTO `package` (`id`, `tenant_id`, `shipper_id`, `client_id`, `upload_file_id`, `order_id`, `shipment_id`, `client_package_id`, `tracking_number`, `barcode`, `qr_code`, `status_id`, `zone_id`, `work_area_id`, `carrier_id`, `service_level_id`, `vehicle_type_id`, `driver_id`, `ship_from_hub_id`, `ship_from_name`, `ship_from_address_1`, `ship_from_address_2`, `ship_from_city_locality`, `ship_from_state_province`, `ship_from_postal_code`, `ship_from_country`, `ship_from_lat`, `ship_from_long`, `ship_to_name`, `ship_to_address_1`, `ship_to_address_2`, `ship_to_city_locality`, `ship_to_state_province`, `ship_to_country`, `ship_to_lat`, `ship_to_long`, `ship_to_residential_or_commercial`, `ship_to_is_po_box`, `ship_to_is_apo_fpo`, `ship_to_is_high_rise`, `customer_email_address`, `customer_phone`, `customer_whatsapp`, `delivery_instructions`, `do_not_safe_drop`, `delivery_confirmation`, `signature_required`, `adult_signature_required`, `signature_url`, `addressee_only`, `proof_of_delivery`, `proof_photo_url`, `proof_photo2_url`, `scheduled_delivery_date`, `scheduled_window_from`, `scheduled_window_to`, `actual_delivery_date`, `actual_delivery_time`, `saturday_delivery`, `weight`, `weight_units_id`, `length`, `width`, `height`, `dimension_units_id`, `non_machinable`, `non_standard_packaging`, `is_fragile`, `is_tobacco`, `is_alcohol`, `id_photo_url`, `id_photo2_url`, `is_hazardous`, `is_restricted`, `is_perishable`, `includes_dry_ice`, `temp_control_required`, `is_insured`, `insurance_provider`, `insurance_policy`, `insurance_amount`, `customs_declaration_required`, `importer_of_record`, `exporter_of_record`, `customs_contents_type`, `customs_item_quantity`, `customs_non_delivery_option`, `customs_declaration_number`, `customs_status_id`, `total_minutes`, `total_distance`, `distance_units_id`, `odometer_start`, `odometer_end`, `total_duties_tariffs_taxes`, `base_shipping_rate`, `total_shipping_charges`, `currency_id`, `is_return`, `rma_number`, `return_label_url`, `tags`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 4, 2, NULL, '346257684455', '2356754348', '943687896', '254679445787093357', NULL, NULL, 2, 1, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-05-10 03:41:30', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for package_charge
-- ----------------------------
DROP TABLE IF EXISTS `package_charge`;
CREATE TABLE `package_charge` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `package_id` bigint NOT NULL,
  `rate_contract_id` bigint NOT NULL,
  `charge_type_id` int NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency_id` int DEFAULT NULL,
  `rate_factors` text,
  `stripe_invoice_id` varchar(255) DEFAULT NULL,
  `stripe_invoice_line_item_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_package_charge_tenant_idx` (`tenant_id`),
  KEY `fk_package_charge_package` (`package_id`),
  KEY `fk_package_charge_rate_contract_idx` (`rate_contract_id`) /*!80000 INVISIBLE */,
  KEY `fk_package_charge_currency_idx` (`currency_id`),
  KEY `fk_package_charge_charge_type_idx` (`charge_type_id`),
  CONSTRAINT `fk_package_charge_charge_type` FOREIGN KEY (`charge_type_id`) REFERENCES `charge_type` (`id`),
  CONSTRAINT `fk_package_charge_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`),
  CONSTRAINT `fk_package_charge_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `fk_package_charge_rate_contract` FOREIGN KEY (`rate_contract_id`) REFERENCES `rate_contract` (`id`),
  CONSTRAINT `fk_package_charge_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of package_charge
-- ----------------------------
BEGIN;
INSERT INTO `package_charge` (`id`, `tenant_id`, `package_id`, `rate_contract_id`, `charge_type_id`, `amount`, `currency_id`, `rate_factors`, `stripe_invoice_id`, `stripe_invoice_line_item_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 1, 1, 1, 2.00, 1, NULL, 'in_1234567890abcdefg', 'ii_9876543210gfedcba', '2023-05-10 03:55:51', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for package_event
-- ----------------------------
DROP TABLE IF EXISTS `package_event`;
CREATE TABLE `package_event` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `package_id` bigint NOT NULL,
  `event_type_id` int NOT NULL,
  `description` text,
  `occurred_at` datetime DEFAULT NULL,
  `reason_type_id` int DEFAULT NULL,
  `reason_description` text,
  `user_id` bigint DEFAULT NULL,
  `vehicle_id` bigint DEFAULT NULL,
  `hub_id` bigint DEFAULT NULL,
  `waypoint` varchar(255) DEFAULT NULL,
  `lat` decimal(8,6) DEFAULT NULL,
  `long` decimal(9,6) DEFAULT NULL,
  `total_minutes` decimal(12,6) DEFAULT NULL,
  `total_distance` decimal(12,6) DEFAULT NULL,
  `distance_units_id` int DEFAULT NULL,
  `odometer_start` int DEFAULT NULL,
  `odometer_end` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_package_event_tenant_idx` (`tenant_id`),
  KEY `fk_package_event_hub_idx` (`hub_id`),
  KEY `fk_package_event_vehicle_idx` (`vehicle_id`),
  KEY `fk_package_event_distance_units_idx` (`distance_units_id`),
  KEY `fk_package_event_package_idx` (`package_id`),
  KEY `fk_package_event_user_idx` (`user_id`),
  KEY `fk_package_event_event_type_idx` (`event_type_id`),
  KEY `fk_package_event_reason_type_idx` (`reason_type_id`),
  CONSTRAINT `fk_package_event_distance_units` FOREIGN KEY (`distance_units_id`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_package_event_event_type` FOREIGN KEY (`event_type_id`) REFERENCES `event_type` (`id`),
  CONSTRAINT `fk_package_event_hub` FOREIGN KEY (`hub_id`) REFERENCES `hub` (`id`),
  CONSTRAINT `fk_package_event_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `fk_package_event_reason_type` FOREIGN KEY (`reason_type_id`) REFERENCES `reason_type` (`id`),
  CONSTRAINT `fk_package_event_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_package_event_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_package_event_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle` (`carrier_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of package_event
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for package_file_uploads
-- ----------------------------
DROP TABLE IF EXISTS `package_file_uploads`;
CREATE TABLE `package_file_uploads` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bg_0900_ai_ci NOT NULL,
  `total_count` int DEFAULT '0',
  `accept_count` int DEFAULT '0',
  `reject_count` int DEFAULT '0',
  `loaded_at` timestamp NOT NULL,
  `loaded_by` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bg_0900_ai_ci;

-- ----------------------------
-- Records of package_file_uploads
-- ----------------------------
BEGIN;
INSERT INTO `package_file_uploads` (`id`, `tenant_id`, `filename`, `total_count`, `accept_count`, `reject_count`, `loaded_at`, `loaded_by`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'testfile.json', 0, 0, 0, '2023-06-19 12:13:16', 'Sharmil Hassan', '2023-06-19 12:13:49', 'Sharmil Hassan', '2023-06-19 12:13:16', 'Sharmil Hassan');
COMMIT;

-- ----------------------------
-- Table structure for package_item
-- ----------------------------
DROP TABLE IF EXISTS `package_item`;
CREATE TABLE `package_item` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `package_id` bigint NOT NULL,
  `category` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `sku_description` varchar(255) DEFAULT NULL,
  `upc_code` varchar(12) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `weight` decimal(12,6) DEFAULT NULL,
  `weight_units_id` int DEFAULT NULL,
  `length` decimal(12,6) DEFAULT NULL,
  `height` decimal(12,6) DEFAULT NULL,
  `width` decimal(12,6) DEFAULT NULL,
  `dimension_units_id` int DEFAULT NULL,
  `country_of_manufacture` varchar(2) DEFAULT NULL,
  `country_of_origin` varchar(2) DEFAULT NULL,
  `harmonized_tariff_code` varchar(255) DEFAULT NULL,
  `declared_value` decimal(10,2) DEFAULT NULL,
  `currency_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_package_item_weight_units_idx` (`weight_units_id`),
  KEY `fk_package_item_currency_idx` (`currency_id`),
  KEY `fk_package_item_dimension_units_idx` (`dimension_units_id`),
  KEY `fk_package_item_package_idx` (`package_id`),
  CONSTRAINT `fk_package_item_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`),
  CONSTRAINT `fk_package_item_dimension_units` FOREIGN KEY (`dimension_units_id`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_package_item_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `fk_package_item_weight_units` FOREIGN KEY (`weight_units_id`) REFERENCES `units` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of package_item
-- ----------------------------
BEGIN;
INSERT INTO `package_item` (`id`, `tenant_id`, `package_id`, `category`, `description`, `sku`, `sku_description`, `upc_code`, `quantity`, `weight`, `weight_units_id`, `length`, `height`, `width`, `dimension_units_id`, `country_of_manufacture`, `country_of_origin`, `harmonized_tariff_code`, `declared_value`, `currency_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 'Toys', 'Plush Puppy', NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2023-05-10 04:02:53', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for package_label
-- ----------------------------
DROP TABLE IF EXISTS `package_label`;
CREATE TABLE `package_label` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `package_id` bigint NOT NULL,
  `label_type_id` int DEFAULT NULL,
  `file_format_id` int DEFAULT NULL,
  `label_url` varchar(255) DEFAULT NULL,
  `batch_id` varchar(255) DEFAULT NULL,
  `is_voided` tinyint DEFAULT NULL,
  `voided_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_package_label_tenant_idx` (`tenant_id`),
  KEY `fk_package_label_type_idx` (`label_type_id`),
  KEY `fk_package_lable_file_format_idx` (`file_format_id`),
  KEY `fk_package_label_package_idx` (`package_id`),
  CONSTRAINT `fk_package_label_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `fk_package_label_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_package_label_type` FOREIGN KEY (`label_type_id`) REFERENCES `label_type` (`id`),
  CONSTRAINT `fk_package_lable_file_format` FOREIGN KEY (`file_format_id`) REFERENCES `file_format` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of package_label
-- ----------------------------
BEGIN;
INSERT INTO `package_label` (`id`, `tenant_id`, `package_id`, `label_type_id`, `file_format_id`, `label_url`, `batch_id`, `is_voided`, `voided_at`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 1, 1, NULL, NULL, 0, NULL, '2023-05-10 04:03:33', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for package_metadata
-- ----------------------------
DROP TABLE IF EXISTS `package_metadata`;
CREATE TABLE `package_metadata` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `package_id` bigint NOT NULL,
  `key` varchar(40) NOT NULL,
  `value` varchar(500) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_package_attribute_tenant_idx` (`tenant_id`),
  KEY `fk_package_attribute_package_idx` (`package_id`),
  CONSTRAINT `fk_package_attribute_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `fk_package_attribute_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of package_metadata
-- ----------------------------
BEGIN;
INSERT INTO `package_metadata` (`id`, `tenant_id`, `package_id`, `key`, `value`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 'Manifest Id', '35919797109283', '2023-05-10 04:04:35', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for package_status
-- ----------------------------
DROP TABLE IF EXISTS `package_status`;
CREATE TABLE `package_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_package_status_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_package_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of package_status
-- ----------------------------
BEGIN;
INSERT INTO `package_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Pending Delivery', NULL, NULL, '2023-04-19 17:16:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `package_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Delivered', NULL, NULL, '2023-04-19 17:16:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `package_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'On Hold', NULL, NULL, '2023-04-19 17:16:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `package_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Cancelled', NULL, NULL, '2023-04-19 17:16:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `package_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Returned', NULL, NULL, '2023-04-19 17:16:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `package_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 'Problem / Not Delivered', NULL, NULL, '2023-04-19 17:20:43', 'Tony Sziklai', NULL, NULL);
INSERT INTO `package_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (7, 1, 'Archived', NULL, NULL, '2023-04-19 17:20:43', 'Tony Sziklai', NULL, NULL);
INSERT INTO `package_status` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (8, 1, 'Deleted', NULL, NULL, '2023-04-19 17:20:43', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for package_status_mapping
-- ----------------------------
DROP TABLE IF EXISTS `package_status_mapping`;
CREATE TABLE `package_status_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `package_status_id` int NOT NULL,
  `mapped_name` varchar(255) NOT NULL,
  `mapped_description` varchar(500) DEFAULT NULL,
  `mapped_code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_package_status_mapping_tenant_idx` (`tenant_id`),
  KEY `fk_package_status_mapping_org_idx` (`org_id`),
  KEY `fk_package_status_mapping_package_status_idx` (`package_status_id`),
  CONSTRAINT `fk_package_status_mapping_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_package_status_mapping_package_status` FOREIGN KEY (`package_status_id`) REFERENCES `package_status` (`id`),
  CONSTRAINT `fk_package_status_mapping_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of package_status_mapping
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for pickup
-- ----------------------------
DROP TABLE IF EXISTS `pickup`;
CREATE TABLE `pickup` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `shipper_id` bigint NOT NULL,
  `client_id` bigint DEFAULT NULL,
  `zone_id` bigint DEFAULT NULL,
  `carrier_id` bigint DEFAULT NULL,
  `service_level_id` int DEFAULT NULL,
  `hub_id` bigint DEFAULT NULL,
  `vehicle_type_id` int DEFAULT NULL,
  `driver_id` bigint DEFAULT NULL,
  `pickup_date` date DEFAULT NULL,
  `window_from` time DEFAULT NULL,
  `window_to` time DEFAULT NULL,
  `instructions` text,
  `confirmed_by_carrier` tinyint DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pickup_tenant_idx` (`tenant_id`),
  KEY `fk_pickup_shipper_idx` (`shipper_id`),
  KEY `fk_pickup_client_idx` (`client_id`),
  KEY `fk_pickup_carrier_idx` (`carrier_id`),
  KEY `fk_pickup_hub_idx` (`hub_id`),
  KEY `fk_pickup_driver_idx` (`driver_id`),
  KEY `fk_pickup_vehicle_type_idx` (`vehicle_type_id`),
  KEY `fk_pickup_status_idx` (`status_id`),
  KEY `fk_pickup_zone_idx` (`zone_id`),
  KEY `fk_pickup_service_level_idx` (`service_level_id`),
  CONSTRAINT `fk_pickup_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_pickup_client` FOREIGN KEY (`client_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_pickup_driver` FOREIGN KEY (`driver_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_pickup_hub` FOREIGN KEY (`hub_id`) REFERENCES `hub` (`id`),
  CONSTRAINT `fk_pickup_service_level` FOREIGN KEY (`service_level_id`) REFERENCES `service_level` (`id`),
  CONSTRAINT `fk_pickup_shipper` FOREIGN KEY (`shipper_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_pickup_status` FOREIGN KEY (`status_id`) REFERENCES `pickup_status` (`id`),
  CONSTRAINT `fk_pickup_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_pickup_vehicle_type` FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicle_type` (`id`),
  CONSTRAINT `fk_pickup_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of pickup
-- ----------------------------
BEGIN;
INSERT INTO `pickup` (`id`, `tenant_id`, `shipper_id`, `client_id`, `zone_id`, `carrier_id`, `service_level_id`, `hub_id`, `vehicle_type_id`, `driver_id`, `pickup_date`, `window_from`, `window_to`, `instructions`, `confirmed_by_carrier`, `status_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 4, 2, NULL, 5, NULL, 1, NULL, NULL, '2023-06-01', NULL, NULL, NULL, NULL, NULL, '2023-05-10 04:10:39', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for pickup_package
-- ----------------------------
DROP TABLE IF EXISTS `pickup_package`;
CREATE TABLE `pickup_package` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `pickup_id` bigint NOT NULL,
  `package_id` bigint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pickup_package_tenant_idx` (`tenant_id`),
  KEY `fk_pickup_package_pickup_idx` (`pickup_id`),
  KEY `fk_pickup_package_package_idx` (`package_id`),
  CONSTRAINT `fk_pickup_package_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `fk_pickup_package_pickup` FOREIGN KEY (`pickup_id`) REFERENCES `pickup` (`id`),
  CONSTRAINT `fk_pickup_package_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of pickup_package
-- ----------------------------
BEGIN;
INSERT INTO `pickup_package` (`id`, `tenant_id`, `pickup_id`, `package_id`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 1, '2023-05-10 04:11:24', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for pickup_status
-- ----------------------------
DROP TABLE IF EXISTS `pickup_status`;
CREATE TABLE `pickup_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pickup_status_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_pickup_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of pickup_status
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for pickup_work_area
-- ----------------------------
DROP TABLE IF EXISTS `pickup_work_area`;
CREATE TABLE `pickup_work_area` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `pickup_id` bigint NOT NULL,
  `work_area_id` bigint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pickup_work_area_tenant_idx` (`tenant_id`),
  KEY `fk_pickup_work_area_pickup_idx` (`pickup_id`),
  KEY `fk_pickup_work_area_work_area_idx` (`work_area_id`),
  CONSTRAINT `fk_pickup_work_area_pickup` FOREIGN KEY (`pickup_id`) REFERENCES `pickup` (`id`),
  CONSTRAINT `fk_pickup_work_area_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_pickup_work_area_work_area` FOREIGN KEY (`work_area_id`) REFERENCES `work_area` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of pickup_work_area
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for rate_contract
-- ----------------------------
DROP TABLE IF EXISTS `rate_contract`;
CREATE TABLE `rate_contract` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `shipper_id` bigint NOT NULL,
  `base_rate_type_id` int NOT NULL,
  `carrier_or_client` enum('Carrier','Client') NOT NULL,
  `carrier_id` bigint DEFAULT NULL,
  `client_id` bigint DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `account_number` varchar(255) DEFAULT NULL,
  `po_number` varchar(255) DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `expiration_date` date DEFAULT NULL,
  `net_terms` int DEFAULT NULL,
  `currency_id` int DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  `rate_contract_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rate_contract_tenant_idx` (`tenant_id`),
  KEY `fk_rate_contract_shipper_idx` (`shipper_id`),
  KEY `fk_rate_contract_for_client_idx` (`client_id`),
  KEY `fk_rate_contract_from_carrier_idx` (`carrier_id`),
  KEY `fk_rate_contract_currency_idx` (`currency_id`),
  KEY `fk_rate_contract_status_idx` (`status_id`),
  KEY `fk_rate_contract_base_rate_type_idx` (`base_rate_type_id`),
  CONSTRAINT `fk_rate_contract_base_rate_type` FOREIGN KEY (`base_rate_type_id`) REFERENCES `charge_type` (`id`),
  CONSTRAINT `fk_rate_contract_currency` FOREIGN KEY (`currency_id`) REFERENCES `currency` (`id`),
  CONSTRAINT `fk_rate_contract_for_client` FOREIGN KEY (`client_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_rate_contract_from_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_rate_contract_shipper` FOREIGN KEY (`shipper_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_rate_contract_status` FOREIGN KEY (`status_id`) REFERENCES `rate_contract_status` (`id`),
  CONSTRAINT `fk_rate_contract_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of rate_contract
-- ----------------------------
BEGIN;
INSERT INTO `rate_contract` (`id`, `tenant_id`, `shipper_id`, `base_rate_type_id`, `carrier_or_client`, `carrier_id`, `client_id`, `description`, `account_number`, `po_number`, `effective_date`, `expiration_date`, `net_terms`, `currency_id`, `status_id`, `rate_contract_url`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 4, 2, 'Client', NULL, 2, NULL, NULL, NULL, NULL, NULL, 10, 1, NULL, NULL, '2023-05-02 19:59:28', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for rate_contract_addtl_fee
-- ----------------------------
DROP TABLE IF EXISTS `rate_contract_addtl_fee`;
CREATE TABLE `rate_contract_addtl_fee` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `rate_contract_id` bigint NOT NULL,
  `charge_type_id` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `service_level_id` int DEFAULT NULL,
  `zone_id` bigint DEFAULT NULL,
  `postal_codes` text,
  `percentage_of_base_rate` decimal(5,2) DEFAULT NULL,
  `fee_amount` decimal(10,2) DEFAULT NULL,
  `published_fee` decimal(10,2) DEFAULT NULL,
  `discount_amount` decimal(10,2) DEFAULT NULL,
  `discount_percentage` decimal(5,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rate_contract_addtl_fee_tenant_idx` (`tenant_id`),
  KEY `fk_rate_contract_addtl_fee_contract_idx` (`rate_contract_id`),
  KEY `fk_rate_contract_addtl_fee_zone_idx` (`zone_id`),
  KEY `fk_rate_contract_addtl_fee_service_level_idx` (`service_level_id`),
  KEY `fk_rate_contract_addtl_fee_charge_type_idx` (`charge_type_id`),
  CONSTRAINT `fk_rate_contract_addtl_fee_charge_type` FOREIGN KEY (`charge_type_id`) REFERENCES `charge_type` (`id`),
  CONSTRAINT `fk_rate_contract_addtl_fee_contract` FOREIGN KEY (`rate_contract_id`) REFERENCES `rate_contract` (`id`),
  CONSTRAINT `fk_rate_contract_addtl_fee_service_level` FOREIGN KEY (`service_level_id`) REFERENCES `service_level` (`id`),
  CONSTRAINT `fk_rate_contract_addtl_fee_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_rate_contract_addtl_fee_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Design Pending';

-- ----------------------------
-- Records of rate_contract_addtl_fee
-- ----------------------------
BEGIN;
INSERT INTO `rate_contract_addtl_fee` (`id`, `tenant_id`, `rate_contract_id`, `charge_type_id`, `description`, `service_level_id`, `zone_id`, `postal_codes`, `percentage_of_base_rate`, `fee_amount`, `published_fee`, `discount_amount`, `discount_percentage`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 9, NULL, 1, 1, NULL, NULL, 1.00, NULL, NULL, NULL, '2023-05-10 04:14:28', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for rate_contract_base_rate
-- ----------------------------
DROP TABLE IF EXISTS `rate_contract_base_rate`;
CREATE TABLE `rate_contract_base_rate` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `rate_contract_id` bigint NOT NULL,
  `tier` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `service_level_id` int DEFAULT NULL,
  `zone_id` bigint DEFAULT NULL,
  `postal_codes` text,
  `min_value` decimal(12,6) DEFAULT NULL,
  `max_value` decimal(12,6) DEFAULT NULL,
  `units_id` int DEFAULT NULL,
  `rate_amount` decimal(10,2) NOT NULL,
  `published_rate` decimal(10,2) DEFAULT NULL,
  `discount_amount` decimal(10,2) DEFAULT NULL,
  `discount_percentage` decimal(5,2) DEFAULT NULL,
  `rate_minimum` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rate_contract_base_rate_tenant_idx` (`tenant_id`) /*!80000 INVISIBLE */,
  KEY `fk_rate_contract_base_rate_contract_idx` (`rate_contract_id`),
  KEY `FK_rate_contract_base_rate_zone_idx` (`zone_id`),
  KEY `fk_rate_contract_base_rate_service_level_idx` (`service_level_id`),
  KEY `fk_rate_contract_base_rate_units_idx` (`units_id`),
  CONSTRAINT `fk_rate_contract_base_rate_contract` FOREIGN KEY (`rate_contract_id`) REFERENCES `rate_contract` (`id`),
  CONSTRAINT `fk_rate_contract_base_rate_service_level` FOREIGN KEY (`service_level_id`) REFERENCES `service_level` (`id`),
  CONSTRAINT `fk_rate_contract_base_rate_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_rate_contract_base_rate_units` FOREIGN KEY (`units_id`) REFERENCES `units` (`id`),
  CONSTRAINT `FK_rate_contract_base_rate_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of rate_contract_base_rate
-- ----------------------------
BEGIN;
INSERT INTO `rate_contract_base_rate` (`id`, `tenant_id`, `rate_contract_id`, `tier`, `description`, `service_level_id`, `zone_id`, `postal_codes`, `min_value`, `max_value`, `units_id`, `rate_amount`, `published_rate`, `discount_amount`, `discount_percentage`, `rate_minimum`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, '1', NULL, 1, 1, NULL, 0.000000, 3.000000, 1, 2.00, NULL, NULL, NULL, NULL, '2023-05-02 20:03:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `rate_contract_base_rate` (`id`, `tenant_id`, `rate_contract_id`, `tier`, `description`, `service_level_id`, `zone_id`, `postal_codes`, `min_value`, `max_value`, `units_id`, `rate_amount`, `published_rate`, `discount_amount`, `discount_percentage`, `rate_minimum`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 1, '2', NULL, 1, 1, NULL, 4.000000, 6.000000, 1, 3.00, NULL, NULL, NULL, NULL, '2023-05-03 03:15:07', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for rate_contract_status
-- ----------------------------
DROP TABLE IF EXISTS `rate_contract_status`;
CREATE TABLE `rate_contract_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_rate_contract_status_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_rate_contract_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of rate_contract_status
-- ----------------------------
BEGIN;
INSERT INTO `rate_contract_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Draft', '2023-04-19 22:49:33', 'Tony Sziklai', NULL, NULL);
INSERT INTO `rate_contract_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Pending Approval', '2023-04-19 22:49:33', 'Tony Sziklai', NULL, NULL);
INSERT INTO `rate_contract_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Approved', '2023-04-19 22:49:33', 'Tony Sziklai', NULL, NULL);
INSERT INTO `rate_contract_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 'Rejected', '2023-04-19 22:49:34', 'Tony Sziklai', NULL, NULL);
INSERT INTO `rate_contract_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (7, 1, 'Expired', '2023-04-19 22:49:34', 'Tony Sziklai', NULL, NULL);
INSERT INTO `rate_contract_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (8, 1, 'Cancelled', '2023-04-19 22:49:34', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for reason_type
-- ----------------------------
DROP TABLE IF EXISTS `reason_type`;
CREATE TABLE `reason_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `event_type_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_reason_type_tenant_idx` (`tenant_id`),
  KEY `fk_reason_type_event_type_idx` (`event_type_id`),
  CONSTRAINT `fk_reason_type_event_type` FOREIGN KEY (`event_type_id`) REFERENCES `event_type` (`id`),
  CONSTRAINT `fk_reason_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of reason_type
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for reason_type_mapping
-- ----------------------------
DROP TABLE IF EXISTS `reason_type_mapping`;
CREATE TABLE `reason_type_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `reason_type_id` int DEFAULT NULL,
  `mapped_name` varchar(255) DEFAULT NULL,
  `mapped_description` varchar(500) DEFAULT NULL,
  `mapped_code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_reason_type_mapping_tenant_idx` (`tenant_id`),
  KEY `fk_reason_type_mapping_org_idx` (`org_id`),
  KEY `fk_reason_type_mapping_reason_type_idx` (`reason_type_id`),
  CONSTRAINT `fk_reason_type_mapping_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_reason_type_mapping_reason_type` FOREIGN KEY (`reason_type_id`) REFERENCES `reason_type` (`id`),
  CONSTRAINT `fk_reason_type_mapping_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of reason_type_mapping
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for role_type
-- ----------------------------
DROP TABLE IF EXISTS `role_type`;
CREATE TABLE `role_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `permissions` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_role_type_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_role_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of role_type
-- ----------------------------
BEGIN;
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Nearfleet Admin', NULL, NULL, '2023-04-14 21:11:06', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Super Admin', NULL, NULL, '2023-04-14 21:11:06', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Financial Admin', NULL, NULL, '2023-04-14 21:11:06', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Coordinator', NULL, NULL, '2023-04-14 21:11:06', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Dispatcher', NULL, NULL, '2023-04-14 21:11:06', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 'Driver', NULL, NULL, '2023-04-14 21:11:07', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (7, 1, 'Package Handler', NULL, NULL, '2023-04-14 21:13:39', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (8, 1, 'User Access Admin', NULL, NULL, '2023-04-15 17:29:12', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (9, 1, 'Reader All', NULL, NULL, '2023-04-15 22:42:43', 'Tony Sziklai', NULL, NULL);
INSERT INTO `role_type` (`id`, `tenant_id`, `name`, `description`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (10, 1, 'Reader Except Financial', NULL, NULL, '2023-04-15 22:48:06', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for routing_problem
-- ----------------------------
DROP TABLE IF EXISTS `routing_problem`;
CREATE TABLE `routing_problem` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `routing_date` date DEFAULT NULL,
  `zone_id` bigint DEFAULT NULL,
  `service_level_id` int DEFAULT NULL,
  `start_location_id` bigint DEFAULT NULL,
  `earliest_start_time` time DEFAULT NULL,
  `end_location_id` bigint DEFAULT NULL,
  `latest_end_time` time DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  `mb_routing_problem_id` varchar(255) DEFAULT NULL,
  `mb_routing_profile` varchar(255) DEFAULT NULL,
  `mb_status` varchar(255) DEFAULT NULL,
  `mb_error_code` varchar(255) DEFAULT NULL,
  `mb_routing_solution` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_routing_problem_tenant_idx` (`tenant_id`),
  KEY `fk_routing_problem_org_idx` (`org_id`),
  KEY `fk_routing_problem_start_location_idx` (`start_location_id`),
  KEY `fk_routing_problem_end_location_idx` (`end_location_id`),
  KEY `fk_routing_problem_zone_idx` (`zone_id`),
  KEY `fk_routing_problem_service_level_idx` (`service_level_id`),
  KEY `fk_routing_problem_status_idx` (`status_id`),
  CONSTRAINT `fk_routing_problem_end_location` FOREIGN KEY (`end_location_id`) REFERENCES `hub` (`id`),
  CONSTRAINT `fk_routing_problem_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_routing_problem_service_level` FOREIGN KEY (`service_level_id`) REFERENCES `service_level` (`id`),
  CONSTRAINT `fk_routing_problem_start_location` FOREIGN KEY (`start_location_id`) REFERENCES `hub` (`id`),
  CONSTRAINT `fk_routing_problem_status` FOREIGN KEY (`status_id`) REFERENCES `routing_problem_status` (`id`),
  CONSTRAINT `fk_routing_problem_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_routing_problem_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of routing_problem
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for routing_problem_break
-- ----------------------------
DROP TABLE IF EXISTS `routing_problem_break`;
CREATE TABLE `routing_problem_break` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `routing_problem_id` bigint NOT NULL,
  `earliest_start` time DEFAULT NULL,
  `latest_end` time DEFAULT NULL,
  `duration_seconds` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_routing_problem_break_tenant_idx` (`tenant_id`),
  KEY `fk_routing_problem_break_routing_problem_ix` (`routing_problem_id`),
  CONSTRAINT `fk_routing_problem_break_routing_problem` FOREIGN KEY (`routing_problem_id`) REFERENCES `routing_problem` (`id`),
  CONSTRAINT `fk_routing_problem_break_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of routing_problem_break
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for routing_problem_package
-- ----------------------------
DROP TABLE IF EXISTS `routing_problem_package`;
CREATE TABLE `routing_problem_package` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `routing_problem_id` bigint NOT NULL,
  `package_id` bigint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_routing_problem_package_tenant_idx` (`tenant_id`),
  KEY `fk_routing_problem_package_routing_problem_idx` (`routing_problem_id`),
  KEY `fk_routing_problem_package_package_idx` (`package_id`),
  CONSTRAINT `fk_routing_problem_package_package` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`),
  CONSTRAINT `fk_routing_problem_package_routing_problem` FOREIGN KEY (`routing_problem_id`) REFERENCES `routing_problem` (`id`),
  CONSTRAINT `fk_routing_problem_package_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of routing_problem_package
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for routing_problem_route
-- ----------------------------
DROP TABLE IF EXISTS `routing_problem_route`;
CREATE TABLE `routing_problem_route` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `routing_problem_id` bigint NOT NULL,
  `mb_route_info` json NOT NULL,
  `final_route_info` json DEFAULT NULL,
  `carrier_id` bigint DEFAULT NULL,
  `vehicle_id` bigint DEFAULT NULL,
  `driver_id` bigint DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_routing_problem_route_tenant_idx` (`tenant_id`),
  KEY `fk_routing_problem_route_driver_idx` (`driver_id`),
  KEY `fk_routing_problem_route_routing_problem_idx` (`routing_problem_id`),
  KEY `fk_routing_problem_route_vehicle_idx` (`vehicle_id`),
  KEY `fk_routing_problem_route_carrier_idx` (`carrier_id`),
  CONSTRAINT `fk_routing_problem_route_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_routing_problem_route_driver` FOREIGN KEY (`driver_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_routing_problem_route_routing_problem` FOREIGN KEY (`routing_problem_id`) REFERENCES `routing_problem` (`id`),
  CONSTRAINT `fk_routing_problem_route_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_routing_problem_route_vehicle` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicle` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of routing_problem_route
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for routing_problem_status
-- ----------------------------
DROP TABLE IF EXISTS `routing_problem_status`;
CREATE TABLE `routing_problem_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_routing_problem_status_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_routing_problem_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ----------------------------
-- Records of routing_problem_status
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for routing_problem_vehicle
-- ----------------------------
DROP TABLE IF EXISTS `routing_problem_vehicle`;
CREATE TABLE `routing_problem_vehicle` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `routing_problem_id` bigint NOT NULL,
  `vehicle_type_id` int NOT NULL,
  `vehicle_count` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_routing_problem_vehicle_tenant_idx` (`tenant_id`),
  KEY `fk_routing_problem_vehicle_type_idx` (`vehicle_type_id`) /*!80000 INVISIBLE */,
  KEY `fk_routing_problem_vehicle_routing_problem_idx` (`routing_problem_id`) /*!80000 INVISIBLE */,
  CONSTRAINT `fk_routing_problem_vehicle_routing_problem` FOREIGN KEY (`routing_problem_id`) REFERENCES `routing_problem` (`id`),
  CONSTRAINT `fk_routing_problem_vehicle_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_routing_problem_vehicle_type` FOREIGN KEY (`vehicle_type_id`) REFERENCES `vehicle_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of routing_problem_vehicle
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for routing_problem_work_area
-- ----------------------------
DROP TABLE IF EXISTS `routing_problem_work_area`;
CREATE TABLE `routing_problem_work_area` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `routing_problem_id` bigint NOT NULL,
  `work_area_id` bigint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_routing_problem_work_area_tenant_idx` (`tenant_id`),
  KEY `fk_routing_problem_work_area_routing_problem_idx` (`routing_problem_id`),
  KEY `fk_routing_problem_work_area_work_area_idx` (`work_area_id`),
  CONSTRAINT `fk_routing_problem_work_area_routing_problem` FOREIGN KEY (`routing_problem_id`) REFERENCES `routing_problem` (`id`),
  CONSTRAINT `fk_routing_problem_work_area_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_routing_problem_work_area_work_area` FOREIGN KEY (`work_area_id`) REFERENCES `work_area` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of routing_problem_work_area
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for service_level
-- ----------------------------
DROP TABLE IF EXISTS `service_level`;
CREATE TABLE `service_level` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_service_level_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_service_level_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of service_level
-- ----------------------------
BEGIN;
INSERT INTO `service_level` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Same Day', NULL, NULL, '2023-04-27 05:07:27', 'Tony Sziklai', NULL, NULL);
INSERT INTO `service_level` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, '2-Hour', NULL, NULL, '2023-04-27 05:07:27', 'Tony Sziklai', NULL, NULL);
INSERT INTO `service_level` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, '1-Hour', NULL, NULL, '2023-04-27 05:07:28', 'Tony Sziklai', NULL, NULL);
INSERT INTO `service_level` (`id`, `tenant_id`, `name`, `description`, `code`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Scheduled', NULL, NULL, '2023-04-27 05:07:28', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for service_level_mapping
-- ----------------------------
DROP TABLE IF EXISTS `service_level_mapping`;
CREATE TABLE `service_level_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `service_level_id` int NOT NULL,
  `mapped_name` varchar(255) NOT NULL,
  `mapped_description` varchar(500) DEFAULT NULL,
  `mapped_code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_service_level_mapping_tenant_idx` (`tenant_id`),
  KEY `fk_service_level_mapping_org_idx` (`org_id`),
  KEY `fk_service_level_mapping_service_level_idx` (`service_level_id`),
  CONSTRAINT `fk_service_level_mapping_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_service_level_mapping_service_level` FOREIGN KEY (`service_level_id`) REFERENCES `service_level` (`id`),
  CONSTRAINT `fk_service_level_mapping_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of service_level_mapping
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for shipping_invoice
-- ----------------------------
DROP TABLE IF EXISTS `shipping_invoice`;
CREATE TABLE `shipping_invoice` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `shipper_id` bigint NOT NULL,
  `carrier_or_client` enum('Carrier','Client') NOT NULL,
  `carrier_id` bigint DEFAULT NULL,
  `client_id` bigint DEFAULT NULL,
  `stripe_invoice_id` varchar(255) DEFAULT NULL,
  `stripe_payment_intent_id` varchar(255) DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `invoice_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_shipping_invoice_tenant_idx` (`tenant_id`),
  KEY `fk_shipping_invoice_shipper_idx` (`shipper_id`),
  KEY `fk_shipping_invoice_carrier_idx` (`carrier_id`),
  KEY `fk_shipping_invoice_client_idx` (`client_id`),
  KEY `fk_shipping_invoice_status_idx` (`status_id`),
  CONSTRAINT `fk_shipping_invoice_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_shipping_invoice_client` FOREIGN KEY (`client_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_shipping_invoice_shipper` FOREIGN KEY (`shipper_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_shipping_invoice_status` FOREIGN KEY (`status_id`) REFERENCES `invoice_status` (`id`),
  CONSTRAINT `fk_shipping_invoice_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of shipping_invoice
-- ----------------------------
BEGIN;
INSERT INTO `shipping_invoice` (`id`, `tenant_id`, `shipper_id`, `carrier_or_client`, `carrier_id`, `client_id`, `stripe_invoice_id`, `stripe_payment_intent_id`, `status_id`, `due_date`, `invoice_url`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 1, 'Carrier', 4, NULL, 'in_test_1234567890abcdefghijklmnop', 'pi_test_1234567890abcdefghijklmnop', 1, NULL, NULL, '2023-05-10 02:31:18', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for state_province
-- ----------------------------
DROP TABLE IF EXISTS `state_province`;
CREATE TABLE `state_province` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `country` varchar(2) NOT NULL,
  `code` varchar(3) DEFAULT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`,`tenant_id`),
  KEY `fk_state_province_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_state_province_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of state_province
-- ----------------------------
BEGIN;
INSERT INTO `state_province` (`id`, `tenant_id`, `country`, `code`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'US', NULL, 'Los Angeles', '2023-04-17 15:17:40', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tag_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_tag_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of tag
-- ----------------------------
BEGIN;
INSERT INTO `tag` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Oversized', '2023-04-25 00:33:50', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tag` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Overweight', '2023-04-25 00:33:50', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tag` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (11, 1, 'Time-Sensitive', '2023-05-04 13:29:16', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for tax_identifier_type
-- ----------------------------
DROP TABLE IF EXISTS `tax_identifier_type`;
CREATE TABLE `tax_identifier_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tax_identifier_type_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_tax_identifier_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of tax_identifier_type
-- ----------------------------
BEGIN;
INSERT INTO `tax_identifier_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'VAT', '2023-06-12 23:46:29', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tax_identifier_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'TIN', '2023-06-12 23:46:29', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tax_identifier_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'EIN', '2023-06-12 23:46:29', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tax_identifier_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'SSN', '2023-06-12 23:46:30', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tax_identifier_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'EORI', '2023-06-12 23:46:30', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tax_identifier_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 'IOSS', '2023-06-12 23:46:30', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tax_identifier_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (7, 1, 'PAN', '2023-06-12 23:46:30', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tax_identifier_type` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (8, 1, 'VOEC', '2023-06-12 23:46:30', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for tenant
-- ----------------------------
DROP TABLE IF EXISTS `tenant`;
CREATE TABLE `tenant` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  `uuid` varchar(64) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uuid_UNIQUE` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of tenant
-- ----------------------------
BEGIN;
INSERT INTO `tenant` (`id`, `name`, `uuid`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 'ALS', 'e88fe80a-dbbd-11ed-b88e-6045bded84f9', '2023-04-14 17:01:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `tenant` (`id`, `name`, `uuid`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 'Hyper USA', '2a704f23-dbd3-11ed-b88e-6045bded84f9', '2023-04-15 21:19:11', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for units
-- ----------------------------
DROP TABLE IF EXISTS `units`;
CREATE TABLE `units` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `system` enum('Metric','Imperial') NOT NULL,
  `symbol` varchar(10) NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_units_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_units_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of units
-- ----------------------------
BEGIN;
INSERT INTO `units` (`id`, `tenant_id`, `system`, `symbol`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Imperial', 'lb', 'Pound', '2023-04-14 16:19:52', 'Tony Sziklai', NULL, NULL);
INSERT INTO `units` (`id`, `tenant_id`, `system`, `symbol`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Imperial', 'in', 'Inch', '2023-04-14 21:32:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `units` (`id`, `tenant_id`, `system`, `symbol`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Imperial', 'cu ft', 'Cubic Foot', '2023-04-14 21:32:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `units` (`id`, `tenant_id`, `system`, `symbol`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Imperial', 'mi', 'Mile', '2023-04-14 21:32:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `units` (`id`, `tenant_id`, `system`, `symbol`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Imperial', 'hr', 'Hour', '2023-04-14 21:32:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `units` (`id`, `tenant_id`, `system`, `symbol`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 'Imperial', 'min', 'Minute', '2023-04-14 21:32:22', 'Tony Sziklai', NULL, NULL);
INSERT INTO `units` (`id`, `tenant_id`, `system`, `symbol`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (7, 1, 'Imperial', 's', 'Second', '2023-04-14 21:32:22', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `email_address` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `whatsapp_number` varchar(20) DEFAULT NULL,
  `status_id` int DEFAULT NULL,
  `uuid` varchar(64) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `first_name` varchar(80) DEFAULT NULL,
  `last_name` varchar(80) DEFAULT NULL,
  `middle_name` varchar(80) DEFAULT NULL,
  `photo_url` varchar(255) DEFAULT NULL,
  `is_sys_user` tinyint NOT NULL DEFAULT '0',
  `permissions` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email_address_UNIQUE` (`email_address`),
  UNIQUE KEY `uuid_UNIQUE` (`uuid`),
  KEY `fk_user_user_status_idx` (`status_id`),
  KEY `fk_user_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_user_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_user_user_status` FOREIGN KEY (`status_id`) REFERENCES `user_status` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of user
-- ----------------------------
BEGIN;
INSERT INTO `user` (`id`, `tenant_id`, `email_address`, `password`, `phone_number`, `whatsapp_number`, `status_id`, `uuid`, `display_name`, `first_name`, `last_name`, `middle_name`, `photo_url`, `is_sys_user`, `permissions`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'sharmil@ingineous.com', '$2a$10$gnQZHnjirR39pvBe21OaveMaffV5m1scjYhdRL1ZI2H2Smy3waYZy', '661-373-7983', NULL, 1, '18cd5937-4450-4801-5637-e3982845e10f', 'Sharmil', 'Sharmil', 'Hassan', NULL, NULL, 0, NULL, '2023-04-16 18:59:12', NULL, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for user_status
-- ----------------------------
DROP TABLE IF EXISTS `user_status`;
CREATE TABLE `user_status` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_status_tenant_idx` (`tenant_id`),
  CONSTRAINT `fk_user_status_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of user_status
-- ----------------------------
BEGIN;
INSERT INTO `user_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Active', '2023-04-15 23:20:03', 'Tony Sziklai', NULL, NULL);
INSERT INTO `user_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (2, 1, 'Pending', '2023-04-15 23:20:03', 'Tony Sziklai', NULL, NULL);
INSERT INTO `user_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 'Invited', '2023-04-15 23:20:03', 'Tony Sziklai', NULL, NULL);
INSERT INTO `user_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (4, 1, 'Inactive', '2023-04-15 23:20:03', 'Tony Sziklai', NULL, NULL);
INSERT INTO `user_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (5, 1, 'Suspended', '2023-04-15 23:20:04', 'Tony Sziklai', NULL, NULL);
INSERT INTO `user_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (6, 1, 'Archived', '2023-04-15 23:20:04', 'Tony Sziklai', NULL, NULL);
INSERT INTO `user_status` (`id`, `tenant_id`, `name`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (7, 1, 'Deleted', '2023-04-15 23:23:05', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for vehicle
-- ----------------------------
DROP TABLE IF EXISTS `vehicle`;
CREATE TABLE `vehicle` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `carrier_id` bigint NOT NULL,
  `type_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `make` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `model_year` year DEFAULT NULL,
  `license_number` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_vehicle_tenant_idx` (`tenant_id`),
  KEY `fk_vehicle_carrier_idx` (`carrier_id`),
  KEY `fk_vehicle_type_idx` (`type_id`),
  CONSTRAINT `fk_vehicle_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_vehicle_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_vehicle_type` FOREIGN KEY (`type_id`) REFERENCES `vehicle_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of vehicle
-- ----------------------------
BEGIN;
INSERT INTO `vehicle` (`id`, `tenant_id`, `carrier_id`, `type_id`, `name`, `make`, `model`, `model_year`, `license_number`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (3, 1, 2, 1, 'Tesla Electric Truck 1', NULL, NULL, NULL, 'ABC 1234', '2023-05-10 04:44:28', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for vehicle_type
-- ----------------------------
DROP TABLE IF EXISTS `vehicle_type`;
CREATE TABLE `vehicle_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `volume_capacity` decimal(12,6) DEFAULT NULL,
  `volume_units_id` int DEFAULT NULL,
  `weight_capacity` decimal(12,6) DEFAULT NULL,
  `weight_units_id` int DEFAULT NULL,
  `range` decimal(12,6) DEFAULT NULL,
  `range_units_id` int DEFAULT NULL,
  `refrigerated` tinyint DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_vehicle_type_tenant_idx` (`tenant_id`),
  KEY `fk_vehicle_type_volume_units_idx` (`volume_units_id`),
  KEY `fk_vehicle_type_weight_units_idx` (`weight_units_id`),
  KEY `fk_vehicle_type_range_units_idx` (`range_units_id`),
  CONSTRAINT `fk_vehicle_type_range_units` FOREIGN KEY (`range_units_id`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_vehicle_type_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_vehicle_type_volume_units` FOREIGN KEY (`volume_units_id`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_vehicle_type_weight_units` FOREIGN KEY (`weight_units_id`) REFERENCES `units` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of vehicle_type
-- ----------------------------
BEGIN;
INSERT INTO `vehicle_type` (`id`, `tenant_id`, `name`, `description`, `volume_capacity`, `volume_units_id`, `weight_capacity`, `weight_units_id`, `range`, `range_units_id`, `refrigerated`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Tesla Electric Truck', NULL, 100.000000, 3, 10000.000000, 1, 260.000000, 4, NULL, '2023-05-10 04:40:34', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for work_area
-- ----------------------------
DROP TABLE IF EXISTS `work_area`;
CREATE TABLE `work_area` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `zone_id` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `code` varchar(80) DEFAULT NULL,
  `postal_codes` text,
  `geo_polygon` polygon DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_work_area_tenant_idx` (`tenant_id`),
  KEY `fk_work_area_zone_idx` (`zone_id`),
  CONSTRAINT `fk_work_area_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_work_area_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of work_area
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for work_area_carrier
-- ----------------------------
DROP TABLE IF EXISTS `work_area_carrier`;
CREATE TABLE `work_area_carrier` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `work_area_id` bigint NOT NULL,
  `shipper_id` bigint NOT NULL,
  `carrier_id` bigint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_work_area_carrier_tenant_idx` (`tenant_id`),
  KEY `fk_work_area_carrier_work_area_idx` (`work_area_id`),
  KEY `fk_work_area_carrier_shipper_idx` (`shipper_id`),
  KEY `fk_work_area_carrier_carrier_idx` (`carrier_id`),
  CONSTRAINT `fk_work_area_carrier_carrier` FOREIGN KEY (`carrier_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_work_area_carrier_shipper` FOREIGN KEY (`shipper_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_work_area_carrier_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_work_area_carrier_work_area` FOREIGN KEY (`work_area_id`) REFERENCES `work_area` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of work_area_carrier
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for work_area_carrier_driver
-- ----------------------------
DROP TABLE IF EXISTS `work_area_carrier_driver`;
CREATE TABLE `work_area_carrier_driver` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `work_area_carrier_id` bigint NOT NULL,
  `driver_id` bigint NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_work_area_carrier_driver_tenant_idx` (`tenant_id`),
  KEY `fk_work_area_carrier_driver_work_area_carrier_idx` (`work_area_carrier_id`),
  KEY `fk_work_area_carrier_driver_driver_idx` (`driver_id`),
  CONSTRAINT `fk_work_area_carrier_driver_driver` FOREIGN KEY (`driver_id`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_work_area_carrier_driver_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_work_area_carrier_driver_work_area_carrier` FOREIGN KEY (`work_area_carrier_id`) REFERENCES `work_area_carrier` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of work_area_carrier_driver
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for zone
-- ----------------------------
DROP TABLE IF EXISTS `zone`;
CREATE TABLE `zone` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `code` varchar(80) DEFAULT NULL,
  `country` varchar(2) DEFAULT NULL,
  `state_province` varchar(80) DEFAULT NULL,
  `postal_codes` text,
  `geo_polygon` polygon DEFAULT NULL,
  `geo_fence_lat` decimal(8,6) DEFAULT NULL,
  `geo_fence_long` decimal(9,6) DEFAULT NULL,
  `geo_point` point DEFAULT NULL,
  `radius` decimal(6,3) DEFAULT NULL,
  `radius_units` int DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_zone_tenant_idx` (`tenant_id`),
  KEY `fk_zone_radius_units_idx` (`radius_units`),
  CONSTRAINT `fk_zone_radius_units` FOREIGN KEY (`radius_units`) REFERENCES `units` (`id`),
  CONSTRAINT `fk_zone_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of zone
-- ----------------------------
BEGIN;
INSERT INTO `zone` (`id`, `tenant_id`, `name`, `description`, `code`, `country`, `state_province`, `postal_codes`, `geo_polygon`, `geo_fence_lat`, `geo_fence_long`, `geo_point`, `radius`, `radius_units`, `created_at`, `created_by`, `modified_at`, `modified_by`) VALUES (1, 1, 'Los Angeles', NULL, NULL, 'US', 'Los Angeles', '\"90001\", \"90002\", \"90003\", \"90004\", \"90005\", \"90006\", \"90007\", \"90008\", \"90010\", \"90011\", \"90012\", \"90013\", \"90014\", \"90015\", \"90016\", \"90017\", \"90018\", \"90019\", \"90020\", \"90021\", \"90022\", \"90023\", \"90024\", \"90025\", \"90026\", \"90027\", \"90028\", \"90029\", \"90031\", \"90032\", \"90033\", \"90034\", \"90035\", \"90036\", \"90037\", \"90038\", \"90039\", \"90040\", \"90041\", \"90042\", \"90043\", \"90044\", \"90045\", \"90046\", \"90047\", \"90048\", \"90049\", \"90056\", \"90057\", \"90058\", \"90059\", \"90061\", \"90062\", \"90063\", \"90064\", \"90065\", \"90066\", \"90067\", \"90068\", \"90069\", \"90071\", \"90077\", \"90079\", \"90089\", \"90090\", \"90094\", \"90095\", \"90291\", \"90292\", \"90293\", \"90294\", \"90295\", \"91303\", \"91304\", \"91306\", \"91307\", \"91311\", \"91316\", \"91324\", \"91325\", \"91326\", \"91330\", \"91331\", \"91335\", \"91340\", \"91342\", \"91343\", \"91344\", \"91345\", \"91352\", \"91356\", \"91364\", \"91367\", \"91401\", \"91402\", \"91403\", \"91405\", \"91406\", \"91411\", \"91423\", \"91436\", \"91504\", \"91505\", \"91601\", \"91602\", \"91604\", \"91605\", \"91606\", \"91607\"', NULL, 34.052235, -118.243683, NULL, 150.000, NULL, '2023-04-17 15:10:08', 'Tony Sziklai', NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for zone_mapping
-- ----------------------------
DROP TABLE IF EXISTS `zone_mapping`;
CREATE TABLE `zone_mapping` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tenant_id` int NOT NULL,
  `org_id` bigint NOT NULL,
  `zone_id` bigint NOT NULL,
  `mapped_name` varchar(255) NOT NULL,
  `mapped_description` varchar(500) DEFAULT NULL,
  `mapped_code` varchar(80) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` varchar(80) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT NULL,
  `modified_by` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_zone_mapping_tenant_idx` (`tenant_id`),
  KEY `fk_zone_mapping_org_idx` (`org_id`),
  KEY `fk_zone_mapping_zone_idx` (`zone_id`),
  CONSTRAINT `fk_zone_mapping_org` FOREIGN KEY (`org_id`) REFERENCES `org` (`id`),
  CONSTRAINT `fk_zone_mapping_tenant` FOREIGN KEY (`tenant_id`) REFERENCES `tenant` (`id`),
  CONSTRAINT `fk_zone_mapping_zone` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Frozen';

-- ----------------------------
-- Records of zone_mapping
-- ----------------------------
BEGIN;
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
