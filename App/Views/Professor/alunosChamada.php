<?php
    foreach ($this->alunos as $aluno):
        ?>
<div class="aluno">


    <div class="boxes">
        <?php
                        for ($i = 1; $i <= $this->qt_aulas; $i++) {
                            ?>

        <input type="checkbox" name="falta-<?= $aluno->cd_aluno ?>-<?= $i ?>">
        <?php
                        }
                    ?>
    </div>

    <p><?= $aluno->nome_aluno ?></p>
</div>
<?php
    endforeach;
    ?>

<style>
@import url('/assets/css/global.css');

* {
    margin: 0;
    padding: 0;
}

.boxes, p {
    margin: 1px var(--shadow) solid;
}

p {
    display: flex;
    align-items: center;
}

/* div das checkbox */
.boxes {
    padding: 1rem;
}

/* div do nome do aluno */
.aluno {
    display: flex;
}
</style>