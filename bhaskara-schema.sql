-- MySQL Script generated by MySQL Workbench
-- Sun Oct 27 17:41:22 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema db_bhaskara
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `db_bhaskara` ;

-- -----------------------------------------------------
-- Schema db_bhaskara
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_bhaskara` DEFAULT CHARACTER SET utf8mb4 ;
USE `db_bhaskara` ;

-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_aluno`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_aluno` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_aluno` (
  `cd_aluno` INT(6) NOT NULL AUTO_INCREMENT,
  `nome_aluno` VARCHAR(120) NOT NULL,
  `telefone_aluno` VARCHAR(20) NOT NULL,
  `cpf_aluno` VARCHAR(11) NOT NULL,
  `rg_aluno` VARCHAR(12) NOT NULL,
  `nascimento_aluno` DATE NOT NULL,
  `senha_aluno` VARCHAR(100) NOT NULL,
  `dt_cadastro` DATETIME NOT NULL DEFAULT current_timestamp,
  `id_endereco` INT NOT NULL,
  `id_cargo` TINYINT UNSIGNED NOT NULL,
  `id_responsavel` INT NOT NULL,
  `st_aluno` CHAR(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`cd_aluno`),
  INDEX `fk_tb_aluno_tb_endereco2_idx` (`id_endereco` ASC) VISIBLE,
  INDEX `fk_tb_aluno_tb_cargo1_idx` (`id_cargo` ASC) VISIBLE,
  INDEX `fk_tb_aluno_tb_responsavel1_idx` (`id_responsavel` ASC) VISIBLE,
  UNIQUE INDEX `cpf_aluno_UNIQUE` (`cpf_aluno` ASC) VISIBLE,
  CONSTRAINT `fk_tb_aluno_tb_endereco2`
    FOREIGN KEY (`id_endereco`)
    REFERENCES `db_bhaskara`.`tb_endereco` (`cd_endereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_aluno_tb_cargo1`
    FOREIGN KEY (`id_cargo`)
    REFERENCES `db_bhaskara`.`tb_cargo` (`cd_cargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_aluno_tb_responsavel1`
    FOREIGN KEY (`id_responsavel`)
    REFERENCES `db_bhaskara`.`tb_responsavel` (`cd_responsavel`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_aula`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_aula` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_aula` (
  `cd_aula` INT NOT NULL AUTO_INCREMENT,
  `dt_aula` DATETIME NOT NULL DEFAULT current_timestamp,
  `ds_aula` TEXT NOT NULL,
  `id_materia` INT NOT NULL,
  `id_turma` INT NOT NULL,
  `unidade` CHAR(1) NOT NULL,
  `id_periodo_letivo` INT NOT NULL,
  PRIMARY KEY (`cd_aula`),
  INDEX `fk_tb_aula_tb_materia1_idx` (`id_materia` ASC) VISIBLE,
  INDEX `fk_tb_aula_tb_turma1_idx` (`id_turma` ASC) VISIBLE,
  CONSTRAINT `fk_tb_aula_tb_materia1`
    FOREIGN KEY (`id_materia`)
    REFERENCES `db_bhaskara`.`tb_materia` (`cd_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_aula_tb_turma1`
    FOREIGN KEY (`id_turma`)
    REFERENCES `db_bhaskara`.`tb_turma` (`cd_turma`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_cargo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_cargo` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_cargo` (
  `cd_cargo` TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome_cargo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cd_cargo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_docente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_docente` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_docente` (
  `cd_docente` INT NOT NULL AUTO_INCREMENT,
  `nome_docente` VARCHAR(120) NOT NULL,
  `telefone_docente` VARCHAR(20) NOT NULL,
  `cpf_docente` VARCHAR(11) NOT NULL,
  `rg_docente` VARCHAR(12) NOT NULL,
  `email_docente` VARCHAR(255) NOT NULL,
  `senha_docente` VARCHAR(100) NOT NULL,
  `dt_entrada` DATETIME NOT NULL DEFAULT current_timestamp,
  `dt_saida` DATETIME NULL,
  `st_docente` CHAR(1) NOT NULL DEFAULT 'A',
  `id_endereco` INT NOT NULL,
  `id_cargo` TINYINT UNSIGNED NOT NULL,
  PRIMARY KEY (`cd_docente`),
  INDEX `fk_tb_funcionario_tb_endereco1_idx` (`id_endereco` ASC) VISIBLE,
  INDEX `fk_tb_docente_tb_cargo1_idx` (`id_cargo` ASC) VISIBLE,
  UNIQUE INDEX `email_docente_UNIQUE` (`email_docente` ASC) VISIBLE,
  UNIQUE INDEX `rg_docente_UNIQUE` (`rg_docente` ASC) VISIBLE,
  UNIQUE INDEX `cpf_docente_UNIQUE` (`cpf_docente` ASC) VISIBLE,
  CONSTRAINT `fk_tb_funcionario_tb_endereco1`
    FOREIGN KEY (`id_endereco`)
    REFERENCES `db_bhaskara`.`tb_endereco` (`cd_endereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_docente_tb_cargo1`
    FOREIGN KEY (`id_cargo`)
    REFERENCES `db_bhaskara`.`tb_cargo` (`cd_cargo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_endereco`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_endereco` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_endereco` (
  `cd_endereco` INT NOT NULL AUTO_INCREMENT,
  `uf` CHAR(2) NOT NULL,
  `cidade` VARCHAR(120) NOT NULL,
  `bairro` VARCHAR(120) NOT NULL,
  `logradouro` VARCHAR(120) NOT NULL,
  `numero` INT NOT NULL,
  `complemento` VARCHAR(100) NOT NULL,
  `cep` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`cd_endereco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_falta`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_falta` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_falta` (
  `cd_falta` INT NOT NULL AUTO_INCREMENT,
  `id_aula` INT NOT NULL,
  `id_periodo_letivo` INT NOT NULL,
  `id_matricula` INT(6) NOT NULL,
  `st_falta` CHAR(1) NOT NULL DEFAULT 'A',
  `unidade` CHAR(1) NOT NULL,
  PRIMARY KEY (`cd_falta`),
  INDEX `fk_tb_falta_tb_aula2_idx` (`id_aula` ASC) VISIBLE,
  INDEX `fk_tb_falta_tb_matricula_turma1_idx` (`id_periodo_letivo` ASC, `id_matricula` ASC) VISIBLE,
  CONSTRAINT `fk_tb_falta_tb_aula2`
    FOREIGN KEY (`id_aula`)
    REFERENCES `db_bhaskara`.`tb_aula` (`cd_aula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_falta_tb_matricula_turma1`
    FOREIGN KEY (`id_periodo_letivo` , `id_matricula`)
    REFERENCES `db_bhaskara`.`tb_matricula_turma` (`id_periodo_letivo` , `id_matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_materia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_materia` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_materia` (
  `cd_materia` INT NOT NULL AUTO_INCREMENT,
  `nm_materia` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`cd_materia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_matricula`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_matricula` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_matricula` (
  `id_aluno` INT(6) NOT NULL,
  `id_periodo_letivo` INT NOT NULL,
  `st_matricula` CHAR(1) NOT NULL DEFAULT 'A',
  PRIMARY KEY (`id_aluno`, `id_periodo_letivo`),
  INDEX `fk_tb_matricula_tb_periodo_letivo1_idx` (`id_periodo_letivo` ASC) VISIBLE,
  CONSTRAINT `fk_tb_matricula_tb_aluno1`
    FOREIGN KEY (`id_aluno`)
    REFERENCES `db_bhaskara`.`tb_aluno` (`cd_aluno`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_matricula_tb_periodo_letivo1`
    FOREIGN KEY (`id_periodo_letivo`)
    REFERENCES `db_bhaskara`.`tb_periodo_letivo` (`cd_periodo_letivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_matricula_turma`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_matricula_turma` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_matricula_turma` (
  `id_matricula` INT(6) NOT NULL,
  `id_periodo_letivo` INT NOT NULL,
  `id_turma` INT NOT NULL,
  PRIMARY KEY (`id_periodo_letivo`, `id_matricula`),
  INDEX `fk_tb_aluno_has_tb_turma_tb_turma1_idx` (`id_turma` ASC) VISIBLE,
  INDEX `fk_tb_aluno_turma_tb_matricula1_idx` (`id_matricula` ASC, `id_periodo_letivo` ASC) VISIBLE,
  CONSTRAINT `fk_tb_aluno_has_tb_turma_tb_turma1`
    FOREIGN KEY (`id_turma`)
    REFERENCES `db_bhaskara`.`tb_turma` (`cd_turma`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_aluno_turma_tb_matricula1`
    FOREIGN KEY (`id_matricula` , `id_periodo_letivo`)
    REFERENCES `db_bhaskara`.`tb_matricula` (`id_aluno` , `id_periodo_letivo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_nota`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_nota` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_nota` (
  `cd_nota` INT NOT NULL AUTO_INCREMENT,
  `valor_nota` DECIMAL(4,2) NOT NULL,
  `peso_nota` TINYINT UNSIGNED NOT NULL,
  `dt_nota` DATE NOT NULL DEFAULT (curdate()),
  `id_periodo_letivo` INT NOT NULL,
  `id_matricula` INT(6) NOT NULL,
  `id_materia` INT NOT NULL,
  `unidade` CHAR(1) NOT NULL,
  PRIMARY KEY (`cd_nota`),
  INDEX `fk_tb_nota_tb_matricula_turma1_idx` (`id_periodo_letivo` ASC, `id_matricula` ASC) VISIBLE,
  INDEX `fk_tb_nota_tb_turma_materia1_idx` (`id_materia` ASC) VISIBLE,
  CONSTRAINT `fk_tb_nota_tb_matricula_turma1`
    FOREIGN KEY (`id_periodo_letivo` , `id_matricula`)
    REFERENCES `db_bhaskara`.`tb_matricula_turma` (`id_periodo_letivo` , `id_matricula`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_nota_tb_turma_materia1`
    FOREIGN KEY (`id_materia`)
    REFERENCES `db_bhaskara`.`tb_turma_materia` (`id_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_periodo_letivo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_periodo_letivo` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_periodo_letivo` (
  `cd_periodo_letivo` INT NOT NULL AUTO_INCREMENT,
  `inicio` DATE NULL,
  `fim` DATE NULL,
  `inicio_ferias` DATE NULL,
  PRIMARY KEY (`cd_periodo_letivo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_responsavel`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_responsavel` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_responsavel` (
  `cd_responsavel` INT NOT NULL AUTO_INCREMENT,
  `nome_responsavel` VARCHAR(120) NOT NULL,
  `telefone_responsavel` VARCHAR(20) NOT NULL,
  `cpf_responsavel` VARCHAR(11) NOT NULL,
  `email_responsavel` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`cd_responsavel`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_turma`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_turma` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_turma` (
  `cd_turma` INT NOT NULL AUTO_INCREMENT,
  `nm_turma` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`cd_turma`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_bhaskara`.`tb_turma_materia`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `db_bhaskara`.`tb_turma_materia` ;

CREATE TABLE IF NOT EXISTS `db_bhaskara`.`tb_turma_materia` (
  `id_turma` INT NOT NULL,
  `id_materia` INT NOT NULL,
  `id_docente` INT NULL,
  PRIMARY KEY (`id_turma`, `id_materia`),
  INDEX `fk_tb_turma_has_tb_materia_tb_materia2_idx` (`id_materia` ASC) VISIBLE,
  INDEX `fk_tb_turma_has_tb_materia_tb_turma2_idx` (`id_turma` ASC) VISIBLE,
  INDEX `fk_tb_turma_materia_tb_docente1_idx` (`id_docente` ASC) VISIBLE,
  CONSTRAINT `fk_tb_turma_has_tb_materia_tb_turma2`
    FOREIGN KEY (`id_turma`)
    REFERENCES `db_bhaskara`.`tb_turma` (`cd_turma`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_turma_has_tb_materia_tb_materia2`
    FOREIGN KEY (`id_materia`)
    REFERENCES `db_bhaskara`.`tb_materia` (`cd_materia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_turma_materia_tb_docente1`
    FOREIGN KEY (`id_docente`)
    REFERENCES `db_bhaskara`.`tb_docente` (`cd_docente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
