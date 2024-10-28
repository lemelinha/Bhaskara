<?php

namespace App\Controllers\Aluno;
use Core\Controller\Controller;
use App\Models\Aluno\Aluno;
use App\Tools\Tools;

class AlunoController extends Controller {
    protected $frequeciaMaterias;
    protected $materias;
    protected $faltas;
    protected $faltas_unidade;
    protected $faltas_total;
    
    public function __construct() {
        if(!isset($_SESSION['logged']) || $_SESSION['logged']['tipo'] != 'aluno'){
            header('Location: /login');
            die();
        }
    }
    
    public function Home() {
        $this->render('Home', 'AlunoLayout', 'Aluno');
    }

    public function Aulas() {
        $Aluno = new Aluno();

        $this->materias = $Aluno->GetMaterias();
        $aux = $Aluno->GetFaltas($_GET['unidade']??UNIDADE);

        foreach ($aux as $falta) {
            $this->faltas[$falta->dt_aula][] = $falta;
        }

        foreach ($this->materias as $materia) {
            $this->frequeciaMaterias[$materia->cd_materia] = $Aluno->GetFrequenciaMateria($materia->cd_materia, $_GET['unidade']??UNIDADE);
            $this->frequeciaMaterias[$materia->cd_materia]->cd_materia = $materia->cd_materia;
        }
        if (!Tools::isAjax()){
            $this->render('Frequencia', 'AlunoLayout', 'Aluno');
            die();
        }
        //var_dump($this->frequeciaMaterias);
        ob_start();
        $this->renderView('tabelaFrequencia', 'Aluno');
        $frequencia = ob_get_clean();
        ob_start();
        $this->renderView('faltas', 'Aluno');
        $faltas = ob_get_clean();
        echo json_encode(['frequencia' => $frequencia, 'faltas' => $faltas]);
    }
}