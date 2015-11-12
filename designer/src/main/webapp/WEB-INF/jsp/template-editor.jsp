<!--
  ~ ADL Designer
  ~ Copyright (c) 2013-2014 Marand d.o.o. (www.marand.com)
  ~
  ~ This file is part of ADL2-tools.
  ~
  ~ ADL2-tools is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU Affero General Public License as
  ~ published by the Free Software Foundation, either version 3 of the
  ~ License, or (at your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU Affero General Public License for more details.
  ~
  ~ You should have received a copy of the GNU Affero General Public License
  ~ along with this program.  If not, see <http://www.gnu.org/licenses/>.
  -->

<html>
<head>
    <title>Template Editor</title>


    <!-- jquery -->
    <script src="lib/jquery/jquery-1.11.1.js"></script>

    <!-- streamjs -->
    <script src="lib/streamjs-1.3.0/stream.js"></script>

    <!-- jquery jstree -->
    <link href="lib/jquery/jstree-3.2.1/themes/default/style.css" rel="stylesheet" type="text/css"/>
    <script src="lib/jquery/jstree-3.2.1/jstree.js"></script>

    <!-- toastr -->
    <link href="lib/jquery/toastr/bower_components/toastr/toastr.min.css" rel="stylesheet" type="text/css"/>
    <script src="lib/jquery/toastr/bower_components/toastr/toastr.min.js"></script>



    <!-- Bootstrap -->
    <link href="lib/bootstrap-3.3.2/css/bootstrap.css" rel="stylesheet" type="text/css"/>
    <script src="lib/bootstrap-3.3.2/js/bootstrap.js"></script>

    <link href="//cdnjs.cloudflare.com/ajax/libs/x-editable/1.5.0/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet"/>
    <script src="//cdnjs.cloudflare.com/ajax/libs/x-editable/1.5.0/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
    <!-- Bootstrap Table -->
    <link href="lib/bootstrap-table-1.6.0/bootstrap-table.min.css" rel="stylesheet" type="text/css"/>
    <script src="lib/bootstrap-table-1.6.0/bootstrap-table.min.js"></script>

    <!-- Handlebars -->
    <script src="lib/handlebars-v2.0.0.js"></script>

    <!-- CodeMirror -->
    <!-- does not use full editor for adl syntax highlight, uses runmode-standalone instead -->
    <!--<link href="lib/codemirror-5.1/lib/codemirror.css" rel="stylesheet" type="text/css"/>-->
    <!--<script src="lib/codemirror-5.1/lib/codemirror.js"></script>-->
    <!--<script src="lib/codemirror-5.1/addon/runmode/runmode.js"></script>-->
    <script src="lib/codemirror-5.1/addon/runmode/runmode-standalone.js"></script>
    <!-- CodeMirror ADL mode -->
    <link href="lib/codemirror-5.1/theme/adl.css" rel="stylesheet" type="text/css"/>
    <script src="lib/codemirror-5.1/mode/adl/adl.js"></script>


    <!-- Bootstrap Select -->
    <link href="lib/bootstrap-select-v1.7.2.0/css/bootstrap-select.min.css" rel="stylesheet" type="text/css"/>
    <script src="lib/bootstrap-select-v1.7.2.0/js/bootstrap-select.min.js"></script>

    <!-- Handle bounce scroll on touch devices -->
    <script src="lib/overscroll.js"></script>

    <!-- Archetype editor -->
    <script src="js/util.js"></script>
    <script src="js/archetype-editor/util-gui.js"></script>
    <script src="js/am/am-model.js"></script>
    <script src="js/am/am-factory.js"></script>
    <script src="js/am/am-mixin.js"></script>
    <script src="js/am/am-template-model.js"></script>
    <script src="js/archetype-editor/core.js"></script>
    <!--<script src="js/archetype-editor/definition.js"></script>-->
    <script src="js/archetype-editor/description.js"></script>
    <script src="js/archetype-editor/terminology.js"></script>
    <!--<script src="js/archetype-editor/display.js"></script>-->

    <script src="js/archetype-editor/module-common.js"></script>
    <script src="js/archetype-editor/module-primitive.js"></script>
    <script src="js/archetype-editor/module-openehr.js"></script>


    <script src="js/archetype-editor/template-editor.js"></script>
    <script src="js/archetype-editor/template-editor-definition.js"></script>
    <script src="js/archetype-editor/template-editor-constraints.js"></script>
    <script src="js/archetype-editor/template-editor-display.js"></script>

    <link href="archetype-editor.css" rel="stylesheet" type="text/css"/>

    <script>
        $().ready(function () {
            $.fn.editable.defaults.mode = 'inline';
            toastr.options.preventDuplicates = true;

            var mytab = $('#archetype-editor-archetype-tabs');
            var ul = mytab.find('ul');

            var el = ul.find('a[href="#archetype-editor-main-tabs-header"]');
            el.tab('show');
            ul.find('a').click(function (e) {
                e.preventDefault();
                $(this).tab('show');
            });

            TemplateEditor.initialize(function () {
            });


        });
    </script>

</head>
<body style="overflow:hidden">
<div id="archetype-editor-main">
	  <nav class="navbar navbar-default navbar-static-top">
	    <div class="container-fluid">
	      <ul class="nav navbar-nav">
	        <li><a href="#" onclick="TemplateEditor.openCreateNewTemplateDialog()">New</a></li>
	        <li><a href="#" onclick="TemplateEditor.openLoadTemplateDialog()">Load</a></li>
	        <li><a href="#" onclick="TemplateEditor.saveCurrentTemplateWithNotification()">Save</a></li>
	      </ul>
		    <ul class="nav navbar-nav navbar-right">
		      <li><a href="#" onclick="TemplateEditor.exportToOpt14()">Export to Opt 1.4</a></li>
		    </ul>
	    </div>
	  </nav>
    <div id="archetype-editor-archetype-id-main"></div>
    <div id="archetype-editor-archetype-tabs" class="tab-pane">

        <ul class="nav nav-tabs">
            <li role="presentation" class="active"><a href="#archetype-editor-main-tabs-description">Description</a></li>
            <li role="presentation"><a href="#archetype-editor-main-tabs-definition">Definition</a></li>
            <li role="presentation"><a href="#archetype-editor-main-tabs-display">Display</a></li>
        </ul>
        <div class="tab-content">

            <div role="tabpanel" class="tab-pane active container-fluid" id="archetype-editor-main-tabs-description">
            </div>
            <div role="tabpanel" class="tab-pane fade container-fluid" id="archetype-editor-main-tabs-definition">
            </div>
            <div role="tabpanel" class="tab-pane fade container-fluid" id="archetype-editor-main-tabs-display">
            </div>

        </div>
    </div>
</div>

</body>

</html>