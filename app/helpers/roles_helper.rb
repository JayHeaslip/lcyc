module RolesHelper

  def render_controller_tree(tree)
    ret = "<ul class='tree'>"

    tree.keys.sort.each do |c|
      ret += '<li>' + c        # list controllers
      actions = tree[c].keys.sort   # get list of actions
      unless actions.empty?
        ret += '<ul>'
        actions.each do |a|
          ret += '<li>' + a + '</li>'
        end
        ret += '</ul>'
      end
    end
    ret += '</ul>'
    ret
  end

  def render_rights_tree(tree)
    ret = "<ul class='tree'>"
    tree.keys.sort.each do |c|
      ret += "<li>" + c     # list controllers
      actions= tree[c].keys.sort # get array of actions
      unless actions.empty?
        ret += '<ul>'
        ret += "<li><a href='#' onclick=\"checkAll('right[#{c}][]'); return false;\">Check All</a>"
        ret += "<li><a href='#' onclick=\"uncheckAll('right[#{c}][]'); return false;\">Uncheck All</a>"
        actions.each do |a|
          if tree[c][a]
            checked = "CHECKED"
          else
            checked = ""
          end
          ret += '<li>' + "<input type='checkbox' name=\"right[#{c}][]\" value=\"#{a}\" #{checked}>" + a + '</li>' # list actions
        end
        ret += '</ul>'
      end
    end
    ret += '</ul>'
    ret
  end

end
