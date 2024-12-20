<?php

namespace App\Models\Docente;
use Core\Model\Model;
use App\Tools\Tools;

class DocenteDocente extends Model {
    public function CadastrarDocente() {
        try {
            $results = $this->executeStatement('SELECT cpf_docente from tb_docente')->fetchAll();
            Tools::decryptRecursive($results);
            foreach ($results as $result) {
                if ($result->cpf_docente == $_POST['cpf']) {
                    echo json_encode(['ok' => false, 'msg' => 'CPF já cadastrado']);
                    die();
                }
            }
            $this->db->beginTransaction();
            $sql = "INSERT INTO
                        tb_endereco
                    VALUES
                        (null, :uf, :cidade, :bairro, :logradouro, :numero, :complemento, :cep)";
            $params = [
                'uf' => $_POST['uf'],
                'cidade' => $_POST['localidade'],
                'bairro' => $_POST['bairro'],
                'logradouro' => $_POST['logradouro'],
                'numero' => $_POST['numero'],
                'complemento' => $_POST['complemento'],
                'cep' => $_POST['cep']
            ];
            $this->executeStatement($sql, $params);
            $id_endereco = $this->db->lastInsertId();

            $senha_inicial = Tools::random_strings(8);
            $sql = "INSERT INTO
                        tb_docente
                    VALUES
                        (null, :nome, :telefone, :cpf, :rg, :email, :senha, default, null, default, :ende, :cargo)";
            $params = [
                'nome' => $_POST['nome'],
                'telefone' => $_POST['telefone'],
                'cpf' => $_POST['cpf'],
                'rg' => $_POST['rg'],
                'email' => $_POST['email'],
                'senha' => password_hash($senha_inicial, PASSWORD_BCRYPT),
                'ende' => $id_endereco,
                'cargo' => $_POST['cargo']
            ];
            $this->executeStatement($sql, $params);

            $this->db->commit();
            echo json_encode(['ok' => true, 'senha' => $senha_inicial]);
        } catch (\Throwable $th) {
            $this->db->rollBack();
            echo json_encode(['ok' => false, 'msg' => 'Verifique as informações inseridas']);
        }
    }

    public function ListarDocentes() {
        $sql = "SELECT 
                    *
                FROM
                    tb_docente
                WHERE
                    st_docente like 'A'
                ORDER BY
                    id_cargo, nome_docente";
        $result = $this->executeStatement($sql)->fetchAll();
        Tools::decryptRecursive($result);
        return $result;
    }

    public function GetDocente($iddocente) {
        $sql = "SELECT
                    *
                FROM
                    tb_docente
                INNER JOIN
                    tb_endereco
                    ON
                        cd_endereco = id_endereco
                WHERE
                    cd_docente = :docente";
        $result = $this->executeStatement($sql, ['docente' => $iddocente])->fetch();
        Tools::decryptRecursive($result);
        return $result;
    }

    public function AtualizarDocente($iddocente) {
        try {
            $smt = $this->executeStatement('SELECT * FROM tb_docente WHERE cd_docente = :docente', ['docente' => $iddocente])->fetch();
            Tools::decryptRecursive($smt);
            $email = $smt->email_docente;
            $cpf = $smt->cpf_docente;
            if ($email != $_POST['email'] || $cpf != $_POST['cpf']) {
                $results = $this->executeStatement('SELECT cpf_docente from tb_docente WHERE cd_docente = :docente', ['docente' => $iddocente])->fetchAll();
                Tools::decryptRecursive($results);
                foreach ($results as $result) {
                    if ($result->cpf_docente == $_POST['cpf'] || $result->email_docente == $_POST['email']) {
                        echo json_encode(['ok' => false, 'msg' => 'CPF ou EMAIL já cadastrado']);
                        die();
                    }
                }
            }
            $this->db->beginTransaction();

            $smt = $this->executeStatement('SELECT id_endereco, id_cargo FROM tb_docente WHERE cd_docente = :docente', ['docente' => $iddocente])->fetch();
            $id_endereco = $smt->id_endereco;
            $id_cargo = $smt->id_cargo;
            $sql = "UPDATE
                        tb_docente
                    SET
                        nome_docente = :nome,
                        rg_docente = :rg,
                        telefone_docente = :telefone,
                        cpf_docente = :cpf,
                        email_docente = :email,
                        id_cargo = :cargo
                    WHERE
                        cd_docente = :docente";
            $params = [
                'docente' => $iddocente,
                'nome' => $_POST['nome'],
                'rg' => $_POST['rg'],
                'telefone' => $_POST['telefone'],
                'cpf' => $_POST['cpf'],
                'email' => $_POST['email'],
                'cargo' => $_POST['cargo']
            ];
            $this->executeStatement($sql, $params);

            $sql = "UPDATE
                        tb_endereco
                    SET
                        uf = :uf, 
                        cidade = :cidade,
                        bairro = :bairro,
                        logradouro = :logradouro,
                        numero = :numero,
                        complemento = :complemento,
                        cep = :cep
                    WHERE
                        cd_endereco = :ende";
            $params = [
                'uf' => $_POST['uf'],
                'cidade' => $_POST['localidade'],
                'bairro' => $_POST['bairro'],
                'logradouro' => $_POST['logradouro'],
                'numero' => $_POST['numero'],
                'complemento' => $_POST['complemento'],
                'cep' => $_POST['cep'],
                'ende' => $id_endereco
            ];
            $this->executeStatement($sql, $params);

            $materiasAlteradas = 0;
            if ($id_cargo == 2 && $_POST['cargo'] != $id_cargo) {
                $sql = "UPDATE
                            tb_turma_materia
                        SET
                            id_docente = null
                        WHERE
                            id_docente = :docente";
                $params = [
                    'docente' => $iddocente
                ];
                $materiasAlteradas = $this->executeStatement($sql, $params)->rowCount();               
            }

            $this->db->commit();
            echo json_encode(['ok' => true, 'msg' => $materiasAlteradas>0?'Atenção! Esse docente era professor, verifique as matérias que ele lecionava':null, 'linhas' => $materiasAlteradas]);
        } catch (\Throwable $th) {
            $this->db->rollBack();
            echo json_encode(['ok' => false, 'msg' => 'Verifique as informações inseridas'.$th->getMessage()]);
        }
    }

    public function DesligarDocente($iddocente) {
        $id_cargo = $this->executeStatement('SELECT id_cargo FROM tb_docente WHERE cd_docente = :docente', ['docente' => $iddocente])->fetch()->id_cargo;
        $sql = "UPDATE
                    tb_docente
                SET
                    dt_saida = NOW(),
                    st_docente = 'I'
                WHERE
                    cd_docente = :docente";
        $this->executeStatement($sql, ['docente' => $iddocente]);
        $materiasAlteradas = 0;
        if ($id_cargo == 2) {
            $sql = "UPDATE
                        tb_turma_materia
                    SET
                        id_docente = null
                    WHERE
                        id_docente = :docente";
            $params = [
                'docente' => $iddocente
            ];
            $materiasAlteradas = $this->executeStatement($sql, $params)->rowCount();               
        }
        echo json_encode(['ok' => true, 'msg' => $materiasAlteradas>0?'Atenção! Esse docente era professor, verifique as matérias que ele lecionava':null, 'linhas' => $materiasAlteradas]);
    }

    public function GetProfessores() {
        $sql = "SELECT
                    *
                FROM
                    tb_docente
                WHERE
                    id_cargo = 2";
        $result = $this->executeStatement($sql)->fetchAll();
        Tools::decryptRecursive($result);
        return $result;
    }

    public function AlterarSenha($cd) {
        $sql = "UPDATE
                    tb_docente
                SET
                    senha_docente = :senha
                WHERE
                    cd_docente = :cd";
        $senha = Tools::random_strings(8);
        $this->executeStatement($sql, ['senha' => password_hash($senha, PASSWORD_BCRYPT), 'cd' => $cd]);
        return $senha;
    }
}
