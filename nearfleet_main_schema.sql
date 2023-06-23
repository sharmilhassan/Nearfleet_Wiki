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

 Date: 23/06/2023 10:51:10
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

SET FOREIGN_KEY_CHECKS = 1;
