class ResponseReorderer
  def reorder! by:
                 rc = RequestCreator.new by, supplies: supplies, \
                                         request: { user_id: user.id, reorder_of_id: id}
    rc.save
    update! replacement: rc.request, cancelled_at: rc.request.created_at
  end

end
