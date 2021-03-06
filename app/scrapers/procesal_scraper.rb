
  #10696737-7
  class ProcesalScraper
    
    def self.search_by_rut(input)
      rut = input.split('-')
      a = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }

      a.get('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf') do |page|
        # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

        # }.submit
        a.cookie_jar
        #page = a.get("http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
      end

      @list=[]
      tribunales = []
      a.page.search('select[name="formConsultaCausas:idSelectedCodeTribunalNom"]').children.each do |n|
        tribunales << n.attr("value")
      end
      tribunales.reject! { |c| c == "-1" || c.nil? }

      ## probar distintos años. Ver si hay algun tribunal que sean todos
      ## almacenar los resultados en la lista
      tribunales.each do |tribunal|
        begin
          page = a.post('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf', {
            #{}"formConsultaCausas:idTabs"=>"idTabRut",
            "formConsultaCausas:idTabs"=>"idTabRut",
            "formConsultaCausas:idValueRadio"=>"1",
            "formConsultaCausas:idFormRut"=>"10696737",
            "formConsultaCausas:idFormRutDv"=>"7",
            "formConsultaCausas:idFormRolInterno"=>"",
            "formConsultaCausas:idFormRolInternoEra"=>"",
            "formConsultaCausas:idSelectedCodeTipCauRef"=>"",
            "formConsultaCausas:idFormRolUnico"=>"",
            "formConsultaCausas:idFormRolUnicoDv"=>"",
            "formConsultaCausas:idSelectedCodeTribunal"=>"",
            "formConsultaCausas:tblListaParticipantes:s"=>"-1",
            "formConsultaCausas:tblListaRelaciones:s"=>"-1",
            "formConsultaCausas:tblListaTramites:s"=>"-1",
            "formConsultaCausas:tblListaNotificaciones:s"=>"-1",
            "formConsultaCausas:idFormNombres"=>"",
            "formConsultaCausas:idFormApPater"=>"",
            "formConsultaCausas:idFormApMater"=>"",
            "formConsultaCausas:idFormFecEra"=>"0",
            "formConsultaCausas:idSelectedCodeTribunalRut"=>tribunal,
            #{}"formConsultaCausas:idSelectedCodeTribunalNom"=>"1245",
            "formConsultaCausas:buscar2.x"=>"50",
            "formConsultaCausas:buscar2.y"=>"9",
            "formConsultaCausas:tblListaConsultaNombres:s"=>"-1",
            "formConsultaCausas:tblListaParticipantesNom:s"=>"-1",
            "formConsultaCausas:tblListaRelacionesNom:"=>"-1",
            "formConsultaCausas:tblListaTramitesNom:s"=>"-1",
            "formConsultaCausas:tblListaNotificacionesNom:s"=>"-1",
            "formConsultaCausas:waitCargaSentOpenedState"=>"",
            "formConsultaCausas"=>"formConsultaCausas",
            "autoScroll"=>"",
            "javax.faces.ViewState"=>a.page.forms[0]['javax.faces.ViewState'],
            "formConsultaCausas:j_id142"=>"formConsultaCausas:j_id142"})

          puts page.content

          @list=[]
          page.search("tr.extdt-firstrow.rich-extdt-firstrow").each do |n|
            #puts 1
            properties = []
            n.search('.texto').each do |content|
                  properties << content.content
            end
            #puts properties
            things = [properties[0].strip,properties[1], "#{properties[2]}-#{properties[3]}", properties[4], properties[5]]
            #puts things
            @list << (things)
          end
        rescue Exception => e
          
        end

      end

       @list.each do |list|
        causa_procesal = ProcesalCausa.new tribunal: list[0].encode('UTF-8', :invalid => :replace, :undef => :replace), tipo: list[1].encode('UTF-8', :invalid => :replace, :undef => :replace), rol_interno: list[2].encode('UTF-8', :invalid => :replace, :undef => :replace), rol_unico: list[3].encode('UTF-8', :invalid => :replace, :undef => :replace), identificacion_causa: list[4].encode('UTF-8', :invalid => :replace, :undef => :replace), estado: list[5].encode('UTF-8', :invalid => :replace, :undef => :replace)#, link: list[7].encode('UTF-8', :invalid => :replace, :undef => :replace)

        # causa_procesal.save
        # general_causa = user.general_causas.build
        # causa_procesal.general_causa = general_causa
        # user.general_causas << general_causa
        # general_causa.save
        # causa_procesal.save
        # user.save
        # puts "Se ha agregado una causa de procesal (por rut)"
        if causa_procesal.save
          puts "Se ha agregado una causa de procesal (por rut)"
        else
          puts "Se ha reasignado una causa procesal existente (por rut)"
          causa_procesal = ProcesalCausa.find_by(rol_interno: list[2].encode('UTF-8', :invalid => :replace, :undef => :replace), rol_unico: list[3].encode('UTF-8', :invalid => :replace, :undef => :replace))
        end
        general_causa = user.general_causas.build
        causa_procesal.general_causa = general_causa
        user.general_causas << general_causa
        general_causa.save
        causa_procesal.save
        user.save
      end

      return @list
    end
    
    def self.search_by_name(a, b, c)
      name, last_name, second_last_name = ""
      name = a.upcase unless a.nil? 
      last_name = b.upcase unless b.nil?
      second_last_name = c.upcase unless c.nil?
      a = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }

      a.get('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf') do |page|
        # search_result = page.form_with(:name => 'InicioAplicacionForm'){ |frm|

        # }.submit
        a.cookie_jar
        #page = a.get("http://corte.poderjudicial.cl/SITCORTEPORWEB/AtPublicoViewAccion.do?tipoMenuATP=1")
      end

      @list=[]
      tribunales = []
      a.page.search('select[name="formConsultaCausas:idSelectedCodeTribunalNom"]').children.each do |n|
        tribunales << n.attr("value")
      end
      tribunales.reject! { |c| c == "-1" || c.nil? }
      #puts tribunales
      ## probar distintos años. Ver si hay algun tribunal que sean todos
      ## almacenar los resultados en la lista
      tribunales.each do |tribunal|
        #puts tribunal
        begin
          page = a.post('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf', {
          "formConsultaCausas:idTabs"=>"idTabNombre",
          "formConsultaCausas:idValueRadio"=>"1",
          "formConsultaCausas:idFormRolInterno"=>"",
          "formConsultaCausas:idFormRolInternoEra"=>"",
          "formConsultaCausas:idSelectedCodeTipCauRef"=>"",
          "formConsultaCausas:idFormRolUnico"=>"",
          "formConsultaCausas:idFormRolUnicoDv"=>"",
          "formConsultaCausas:idSelectedCodeTribunal"=>"",
          "formConsultaCausas:tblListaParticipantes:s"=>"-1",
          "formConsultaCausas:tblListaRelaciones:s"=>"-1",
          "formConsultaCausas:tblListaTramites:s"=>"-1",
          "formConsultaCausas:tblListaNotificaciones:s"=>"-1",
          "formConsultaCausas:idFormNombres"=>name,
          "formConsultaCausas:idFormApPater"=>last_name,
          "formConsultaCausas:idFormApMater"=>second_last_name,
          "formConsultaCausas:idFormFecEra"=>"0",
          "formConsultaCausas:idSelectedCodeTribunalNom"=>27,
          "formConsultaCausas:buscar2.x"=>"50",
          "formConsultaCausas:buscar2.y"=>"9",
          "formConsultaCausas:tblListaConsultaNombres:s"=>"-1",
          "formConsultaCausas:tblListaParticipantesNom:s"=>"-1",
          "formConsultaCausas:tblListaRelacionesNom:"=>"-1",
          "formConsultaCausas:tblListaTramitesNom:s"=>"-1",
          "formConsultaCausas:tblListaNotificacionesNom:s"=>"-1",
          "formConsultaCausas:waitCargaSentOpenedState"=>"",
          "formConsultaCausas"=>"formConsultaCausas",
          "autoScroll"=>"",
          "javax.faces.ViewState"=>a.page.forms[0]['javax.faces.ViewState']})
          
          #puts page
          
          @list=[]
          page.search("tr.extdt-firstrow.rich-extdt-firstrow").each do |n|
            #puts 1
            properties = []
            n.search('.texto').each do |content|
              properties << content.content
            end
            #puts properties            
            things = [properties[0].strip,properties[1], "#{properties[2]}-#{properties[3]}", properties[4], properties[5]]
            puts things



            #puts page.links.map(&:href)
            #search_result = n.click
            #puts search_result

            id_case= n['onclick'][/\(['"]([^)]+)['"]\)/, 1]

            b = Mechanize.new { |agent|
              agent.user_agent_alias = 'Mac Safari'
            }
            page = b.post('http://reformaprocesal.poderjudicial.cl/ConsultaCausasJsfWeb/page/panelConsultaCausas.jsf', {"AJAXREQUEST"=>"_viewRoot",                                                      "formConsultaCausas:idTabs"=>"idTabNombre", "formConsultaCausas:idValueRadio"=>"1","formConsultaCausas:idFormRolInterno"=>"", "formConsultaCausas:idFormRolInternoEra"=>"", "formConsultaCausas:idSelectedCodeTipCauRef"=>"", "formConsultaCausas:idFormRolUnico"=>"", "formConsultaCausas:idFormRolUnicoDv"=>"", "formConsultaCausas:idSelectedCodeTribunal"=>"", "formConsultaCausas:tblListaParticipantes:s"=>"-1", "formConsultaCausas:tblListaRelaciones:s"=>"-1", "formConsultaCausas:tblListaTramites:s"=>"-1", "formConsultaCausas:tblListaNotificaciones:s"=>"-1", "formConsultaCausas:idFormNombres"=>name, "formConsultaCausas:idFormApPater"=>last_name, "formConsultaCausas:idFormApMater"=>second_last_name, "formConsultaCausas:idFormFecEra"=>"0", "formConsultaCausas:idSelectedCodeTribunalNom"=>27, "formConsultaCausas:buscar2.x"=>"50", "formConsultaCausas:buscar2.y"=>"9", "formConsultaCausas:tblListaConsultaNombres:s"=>"-1", "formConsultaCausas:tblListaParticipantesNom:s"=>"-1", "formConsultaCausas:tblListaRelacionesNom:"=>"-1", "formConsultaCausas:tblListaTramitesNom:s"=>"-1", "formConsultaCausas:tblListaNotificacionesNom:s"=>"-1", "formConsultaCausas:waitCargaSentOpenedState"=>"", "formConsultaCausas"=>"formConsultaCausas", "autoScroll"=>"", "javax.faces.ViewState"=>a.page.forms[0]['javax.faces.ViewState'], "formConsultaCausas:j_id144" =>"formConsultaCausas:j_id144",
            "param2"=>id_case,
            "AJAX:EVENTS_COUNT"=>"1"})


            doc = page.search('td.rich-tabpanel-content.textoNegrita table')
            level_2 = doc[24].search('td')[1].search('label')


            fecha = level_2[5].text
            etapa = level_2[6].text

            #ACA HAY 3 CAMPOS: TIPO, NOMBRE Y SITUACION LIBERTAD
            litigantes = []

            doc[28].search('tr').each do |l|
              data = []
              l.search('td').each_with_index do |a,index|
                next if index>2
                data << a.text.strip
              end
              litigantes << data
              puts data.count
            end
            puts litigantes
            @list << (things)

            break
          end  
        rescue Exception => e
          break
        end
        break


      end

      # @list.each do |list|
      #   causa_procesal = ProcesalCausa.new tribunal: list[0].encode('UTF-8', :invalid => :replace, :undef => :replace), tipo: list[1].encode('UTF-8', :invalid => :replace, :undef => :replace), rol_interno: list[2].encode('UTF-8', :invalid => :replace, :undef => :replace), rol_unico: list[3].encode('UTF-8', :invalid => :replace, :undef => :replace), identificacion_causa: list[4].encode('UTF-8', :invalid => :replace, :undef => :replace), estado: list[5].encode('UTF-8', :invalid => :replace, :undef => :replace)#, link: list[7].encode('UTF-8', :invalid => :replace, :undef => :replace)
         
      #   # causa_procesal.save
      #   # general_causa = user.general_causas.build        
      #   # causa_procesal.general_causa = general_causa
      #   # user.general_causas << general_causa
      #   # general_causa.save
      #   # causa_procesal.save
      #   # user.save
      #   # puts "Se ha agregado una causa de procesal (por nombre)"   
      #   if causa_procesal.save
      #     puts "Se ha agregado una causa de procesal (por nombre)"
      #   else
      #     puts "Se ha reasignado una causa procesal existente (por nombre)"
      #     causa_procesal = ProcesalCausa.find_by(rol_interno: list[2].encode('UTF-8', :invalid => :replace, :undef => :replace), rol_unico: list[3].encode('UTF-8', :invalid => :replace, :undef => :replace))
      #   end        
      #   general_causa = user.general_causas.build
      #   causa_procesal.general_causa = general_causa
      #   user.general_causas << general_causa        
      #   general_causa.save
      #   causa_procesal.save
      #   user.save
      # end
          
      return @list
    end

  end

