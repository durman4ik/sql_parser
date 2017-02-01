module Getters
  extend ActiveSupport::Concern

  protected

  def _from
    @from.value
  end

  def _select
    @select.value
  end

  def _group_by
    @group_by.value
  end

  def _order_by
    @order.by.all
  end

  def _limit
    @limit.value
  end

  def _wheres
    @wheres.all
  end

  def _joins
    @joins.all
  end
end
