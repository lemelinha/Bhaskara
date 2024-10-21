<?php

namespace App\Controllers\Professor;
use Core\Controller\Controller;
use App\Models\Docente\DocenteGerenciamento;
use App\Models\Docente\DocenteAluno;
use App\Models\Professor\ProfessorChamada;
use App\Tools\Tools;

class ProfessorController extends Controller {
    protected $professor_materias_turmas;
    protected $turmas;
    protected $alunos;
    protected $cargo;

    public function __construct() {
        if(!isset($_SESSION['logged']) || $_SESSION['logged']['tipo'] != 'professor'){
            header('Location: /login');
            die();
        }
        $this->cargo = $_SESSION['logged']['cargo'];
        if ($this->cargo != 2) {
            header('Location: /login');
            die();
        }
    }

    public function Home() {
        $this->render('home', 'ProfessorLayout', 'Professor');
    }

    public function Chamada() {
        $ProfessorChamada = new ProfessorChamada();

        if ($_SERVER['REQUEST_METHOD'] == 'GET') {
            $aux = $ProfessorChamada->MateriasTurmas($_SESSION['logged']['id']);

            foreach ($aux as $aux2){
                $professor_materia[$aux2->cd_turma] = [];
            }
            foreach ($professor_materia as $t => $m) {
                foreach ($aux as $pm) {
                    if ($pm->id_turma != $t) continue;
                    $professor_materia[$t][$pm->id_materia] = $pm->nm_materia;
                }
            }

            $this->professor_materias_turmas = $professor_materia;
            $this->turmas = (new DocenteGerenciamento)->GetTurmas();

            $this->render('chamada', 'ProfessorLayout', 'Professor');
        }
    }

    public function AlunosPorTurmaChamada($turma, $qt_aulas) {
        $this->qt_aulas = $qt_aulas;
        $this->alunos = (new DocenteAluno)->GetAlunosTurma($turma);
        $this->renderView('alunosChamada', 'Professor');
        die();
    }
}