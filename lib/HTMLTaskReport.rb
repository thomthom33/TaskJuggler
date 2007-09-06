#
# HTMLTaskReport.rb - The TaskJuggler3 Project Management Software
#
# Copyright (c) 2006, 2007 by Chris Schlaeger <cs@kde.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#


require 'ReportBase'
require 'TaskReport'
require 'ReportTable'

class HTMLTaskReport < ReportBase

  include HTMLUtils

  attr_reader :element

  def initialize(project, name)
    super(project, name)
    # This report only has one element.
    @element = ReportElement.new(self)

    # Set the default columns for this report.
    %w( seqno name start end ).each do |col|
      @element.columns << TableColumnDefinition.new(
          col, @element.defaultColumnTitle(col))
    end
    @element.hideResource = LogicalExpression.new(LogicalOperation.new(1))
    @element.sortTasks = [ [ 'start', true, 0 ],
                           [ 'seqno', true, -1 ] ]
  end

  def generate
    report = TaskReport.new(@elements[0])
    table = report.generate

    openFile

    generateHeader

    table.setOut(@file)
    table.to_html(2)

    generateFooter

    closeFile
  end

end

