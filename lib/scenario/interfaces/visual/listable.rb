#    Scenario is a Ruby domain-specific language for graphics.
#    Copyright (C) 2010  Dmitrii Toksaitov
#
#    This file is part of Scenario.
#
#    Released under the MIT License.

module Listable
  def list_id
    @list_id ||= glGenLists(1)
  end

  private
  def apply_list
    glCallList(@list_id) if @list_id
  end
end
