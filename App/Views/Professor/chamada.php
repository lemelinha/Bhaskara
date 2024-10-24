<?php
    if (!EM_PERIODO_LETIVO) {
        ?>
            <p>fora de periodo letivo</p>
        <?php
        die();
    }
?>
<form>
    <select name="turma" id="turma" required>
        <option value="" id="init">Selecione uma turma</option>
        <?php
            foreach($this->turmas as $turma):
                if (!array_key_exists($turma->cd_turma, $this->professor_materias_turmas)) continue;
                ?>
                    <option value="<?= $turma->cd_turma ?>"><?= $turma->nm_turma ?></option>
                    <?php
            endforeach;
            ?>
    </select>
    <select name="materia" id="materia" required disabled>
        <option value="">Selecione uma matéria</option>
        <?php
            $aux = [];
            foreach($this->professor_materias_turmas as $turma):
                foreach ($turma as $id_materia => $materia):
                    if (array_key_exists($id_materia, $aux)) continue;
                    $aux[$id_materia] = $materia;
                    ksort($aux, SORT_NUMERIC);
                endforeach;
            endforeach;
            foreach($aux as $id_materia => $materia):
                ?>
                    <option value="<?= $id_materia ?>"><?= $materia ?></option>
                <?php
            endforeach;
        ?>
    </select>
    <select name="qt_aulas" id="qt_aulas" disabled>
        <option value="1">1 aula</option>
        <option value="2">2 aulas</option>
        <option value="3">3 aulas</option>
    </select>
    <div class="alunos">

    </div>
    <textarea name="ds_aula" id="ds_aula" disabled required></textarea>
    <p class="retorno"></p>
    <input type="submit" value="Enviar" disabled>
    <script>
        let professor_materia = <?= json_encode($this->professor_materias_turmas) ?>;

        $('form').on('submit', function (e) {
            e.preventDefault()

            $.ajax({
                'url': '/professor/chamada',
                'type': 'POST',
                'dataType': 'json',
                'data': $(this).serialize()
            })
            .done(function (data) {
                $('p.retorno').text(data.msg)
                $('form').trigger("reset")
                $('input[type="submit"]').prop('disabled', true)
            })
            .catch(function (a) {
                console.log(a)
            })
        })

        $('form select#turma').on('change', function () {
            $('form select#turma option#init').remove()
            $('form select#qt_aulas').prop('disabled', false)
            $('form select#materia').prop('disabled', false)
            $('form textarea').prop('disabled', false)
            $('input[type="submit"]').prop('disabled', false)

            let turma = $(this).val()
            $('form select#materia option').each(function () {
                if ($(this).val() in professor_materia[turma]) {
                    $(this).css('display', 'block')
                } else {
                    $(this).css('display', 'none')
                }
            })
            $('form select#materia').val('')
            $.ajax({
                'url': `/professor/chamada/alunos/turma/${$('form select#turma').val()}/qa/${$('form select#qt_aulas').val()}`,
                'type': 'GET',
                'dataType': 'html'
            })
            .done(function (data) {
                $('.alunos').html(data)
            })
        })

        $('form select#qt_aulas').on('change', function () {
            $.ajax({
                'url': `/professor/chamada/alunos/turma/${$('form select#turma').val()}/qa/${$('form select#qt_aulas').val()}`,
                'type': 'GET',
                'dataType': 'html'
            })
            .done(function (data) {
                $('.alunos').html(data)
            })
        })
    </script>
</form>